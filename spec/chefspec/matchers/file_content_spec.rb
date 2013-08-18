require 'spec_helper'

describe 'ChefSpec::Matchers#create_file_with_content' do
  let(:matcher) { create_file_with_content('/etc/config_file', 'platform: chefspec') }
  let(:regex_matcher) { create_file_with_content('/etc/config_file', /platform: (.+)/) }

  describe '#match' do
    ['cookbook_file', 'file', 'template'].each do |type|
      context "a #{type} resource" do
        [:create, :create_if_missing].each do |action|
          let(:stub_method) { "content_from_#{type}".to_sym }
          let(:resource) do
            {
              node: {},
              resources: [{
                resource_name: type,
                name: '/etc/config_file',
                action: action,
              }]
            }
          end

          it 'does not match with no content' do
            matcher.stub(stub_method).and_return('')
            expect(matcher).to_not be_matches(resource)
          end

          it 'does not match with the wrong path' do
            matcher.stub(stub_method).and_return('platform: chefspec')
            resource[:resources].first[:name] = '/etc/wrong_config_file'
            expect(matcher).to_not be_matches(resource)
          end

          it 'matches with the right content and path' do
            matcher.stub(stub_method).and_return('platform: chefspec')
            expect(matcher).to be_matches(resource)
          end

          it 'matches partial file contents' do
            matcher.stub(stub_method).and_return("fqdn: chefspec.local\nplatform: chefspec\nhostname: chefspec")
            expect(matcher).to be_matches(resource)
          end

          it 'does not match regex with no context' do
            regex_matcher.stub(stub_method).and_return('')
            expect(regex_matcher).to_not be_matches(resource)
          end

          it 'does not match regex with the wrong path' do
            regex_matcher.stub(stub_method).and_return('platform: chefspec')
            resource[:resources].first[:name] = '/etc/wrong_config_file'
            expect(regex_matcher).to_not be_matches(resource)
          end

          it 'matches regex with the right content and path' do
            regex_matcher.stub(stub_method).and_return('platform: chefspec')
            expect(regex_matcher).to be_matches(resource)
          end
        end
      end
    end
  end
end

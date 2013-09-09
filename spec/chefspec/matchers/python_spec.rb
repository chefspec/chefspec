require 'spec_helper'

module ChefSpec
  module Matchers
    describe :python_pip do
      ['install', 'remove', 'upgrade', 'purge'].each do |action|
        describe "##{action}" do
          let(:name) { 'foo-bar' }
          let(:resource) do
            {
              node: {},
              resources: [{
                resource_name: 'python_pip',
                action: action.to_sym,
                name: name
              }]
            }
          end

          context 'using a string' do
            let(:matcher) { eval("#{action}_python_pip('#{name}')") }

            it 'does not match when no resource exists' do
              expect(matcher).to_not be_matches({ resources: [] })
            end

            it 'does not match when the package is not installed' do
              resource[:resources].first[:name] = 'qux'
              expect(matcher).to_not be_matches(resource)
            end

            it 'matches when the python package exists' do
              expect(matcher).to be_matches(resource)
            end
          end

          context 'using a regular expression' do
            let(:regex_matcher) { eval("#{action}_python_pip(/foo-(.+)/)") }

            it 'does not match when no resource exists' do
              expect(regex_matcher).to_not be_matches({ resources: [] })
            end

            it 'does not match when the package is not installed' do
              resource[:resources].first[:name] = 'qux'
              expect(regex_matcher).to_not be_matches(resource)
            end

            it 'matches when the python package exists' do
              expect(regex_matcher).to be_matches(resource)
            end
          end
        end
      end
    end
  end
end

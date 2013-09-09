require 'spec_helper'

module ChefSpec
  module Matchers
    describe :install_windows_package_at_version do
<<<<<<< HEAD
      describe "#match" do
        let(:matcher) { install_windows_package_at_version('foo', '1.2.3') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match when there are no packages" do
          matcher.matches?({:resources => [{:resource_name => 'template', :path => '/tmp/config.conf',
            :source => 'config.conf.erb'}]}).should be false
        end
        it "should not match if is a different package and an unspecified version" do
          matcher.matches?({:resources => [{:resource_name => 'windows_package', :package_name => 'bar', :version => nil, :action => :install}]}).should be false
        end
        it "should match if is the same package, the correct version and the install action" do
          matcher.matches?({:resources => [{:resource_name => 'windows_package', :package_name => 'foo', :version => '1.2.3', :action => :install}]}).should be true
        end
=======
      describe '#match' do
        let(:matcher) { install_windows_package_at_version('foo', '1.2.3') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match when there are no packages' do
          expect(matcher).to_not be_matches({ resources: [{
            resource_name: 'template',
            path: '/tmp/config.conf',
            source: 'config.conf.erb' }]
          })
        end

        it 'does not match if package differs and version is unspecified' do
          expect(matcher).to_not be_matches({ resources: [{
            resource_name: 'windows_package',
            package_name: 'bar',
            version: nil,
            action: :install }]
          })
        end

        it 'does match if package & version correct, with install action' do
          expect(matcher).to be_matches({ resources: [{
            resource_name: 'windows_package',
            package_name: 'foo',
            version: '1.2.3',
            action: :install }]
          })
        end

>>>>>>> refs/heads/windows_package
      end
    end
  end
end

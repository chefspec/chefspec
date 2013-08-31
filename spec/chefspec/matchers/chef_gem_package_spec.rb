require 'spec_helper'

module ChefSpec
  module Matchers
    describe :install_chef_gem_at_version do
      describe '#match' do
        let(:matcher) { install_chef_gem_at_version('foo', '1.2.3') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match when there are no chef gem packages' do
          expect(matcher).to_not be_matches({
            resources: [{
              resource_name: 'template',
              path: '/tmp/config.conf',
              source: 'config.conf.erb',
            }]
          })
        end

        it 'does not match if is a different chef gem package and an unspecified version' do
          expect(matcher).to_not be_matches({
            resources: [{
              resource_name: 'chef_gem',
              package_name: 'bar',
              version: nil,
              action: :install,
            }]
          })
        end

        it 'does not match if it is the same chef gem package and version but a different action' do
          expect(matcher).to_not be_matches({
            resources: [{
              resource_name: 'chef_gem',
              package_name: 'foo',
              version: '1.2.3',
              action: :upgrade,
            }]
          })
        end

        it 'match if is the same chef gem package, the correct version and the install action' do
          expect(matcher).to be_matches({
            resources: [{
              resource_name: 'chef_gem',
              package_name: 'foo',
              version: '1.2.3',
              action: :install,
            }]
          })
        end
      end
    end
  end
end

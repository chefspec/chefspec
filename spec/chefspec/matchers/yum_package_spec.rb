require 'spec_helper'

module ChefSpec
  module Matchers
    describe :install_yum_package_at_version do
      describe '#match' do
        let(:matcher) { install_yum_package_at_version('foo', '1.2.3') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match when there are no packages' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'template',
              path: '/tmp/config.conf',
              source: 'config.conf.erb'
            }]
          })
        end

        it 'does not match if is a different package and an unspecified version' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'yum_package',
              package_name: 'bar',
              version: nil,
              action: :install
            }]
          })
        end

        it 'does not match if it is the same package and version but a different action' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'package',
              yum_package_name: 'foo',
              version: '1.2.3',
              action: :upgrade
            }]
          })
        end

        it 'matches if is the same package, the correct version and the install action' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'yum_package',
              package_name: 'foo',
              version: '1.2.3',
              action: :install
            }]
          })
        end
      end
    end
  end
end

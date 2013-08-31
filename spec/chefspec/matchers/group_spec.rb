require 'spec_helper'

module ChefSpec
  module Matchers
    describe :group do
      describe '#match' do
        let(:matcher) { create_group('foo') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match when there are no group' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'package',
              package_name: 'vim-enhanced'
            }]
          })
        end

        it 'matches when the group exists' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'group',
              group_name: 'foo',
              action: :create
            }]
          })
        end

        it 'does not match when the group name is different' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'group',
              group_name: 'bar'
            }]
          })
        end
      end
    end
  end
end

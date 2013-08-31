require 'spec_helper'

module ChefSpec
  module Matchers
    describe :user do
      describe '#match' do
        let(:matcher) { create_user 'foo' }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match when there are no users' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'package',
              package_name: 'vim-enhanced'
            }]
          })
        end

        it 'matches when the user exists' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'user',
              username: 'foo',
              action: :create
            }]
          })
        end

        it 'does not match when the user name is different' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'user',
              username: 'bar'
            }]
          })
        end
      end
    end
  end
end

require 'spec_helper'

module ChefSpec
  module Matchers
    describe :env do
      let(:matcher) { create_env('java_home') }

      let(:chef_run) do
        {
          node: {},
          resources: [{
            resource_name: 'env',
            key_name: 'java_home'
          }]
        }
      end

      describe :create_env do
        let(:matcher) { create_env('java_home') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does match when the env resource exist' do
          chef_run[:resources].first[:action] = :create
          expect(matcher).to be_matches(chef_run)
        end

        it 'does not match when the env resource with another name exist' do
          chef_run[:resources].first[:key_name] = 'not_java_home'
          expect(matcher).to_not be_matches(chef_run)
        end
      end

      describe :delete_env do
        let(:matcher) { delete_env('java_home') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'matches when the env resource exist and the action is delete' do
          chef_run[:resources].first[:action] = :delete
          expect(matcher).to be_matches(chef_run)
        end

        it 'does not match when the env resource with another name exist' do
          chef_run[:resources].first[:key_name] = 'not_java_home'
          expect(matcher).to_not be_matches(chef_run)
        end
      end

      describe :modify_env do
        let(:matcher) { modify_env('java_home') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'matches when the env resource exist' do
          chef_run[:resources].first[:action] = :modify
          expect(matcher).to be_matches(chef_run)
        end

        it 'does not match when the env resource with modify action but with another name exist' do
          chef_run[:resources].first[:key_name] = 'not_java_home'
          expect(matcher).to_not be_matches(chef_run)
        end
      end
    end
  end
end

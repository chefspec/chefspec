require 'spec_helper'

module ChefSpec
  module Matchers
    describe :script do
      describe '#match' do
        let(:matcher) { execute_bash_script('foo') }

        it 'should not match when no resources exist' do
          matcher.matches?(:resources => []).should be false
        end

        it 'should match when bash resource exists' do
          resources = [{:resource_name => 'bash', :name => 'foo'}]
          matcher.matches?(:resources => resources).should be true
        end

        it 'should match when script resource with bash interpreter exists' do
          resources = [{:resource_name => 'script', :interpreter => 'bash', :name => 'foo'}]
          matcher.matches?(:resources => resources).should be true
        end

        it 'should match when there is another bash resource' do
          resources = [{:resource_name => 'bash', :name => 'foo'},
                       {:resource_name => 'bash', :name => 'bar'}]
          matcher.matches?(:resources => resources).should be true
        end

        it 'should not match when bash resource with another name exists' do
          resources = [{:resource_name => 'bash', :name => 'bar'}]
          matcher.matches?(:resources => resources).should be false
        end

        it 'should not match when script resource with another interpreter exists' do
          resources = [{:resource_name => 'script', :interpreter => 'perl', :name => 'foo'}]
          matcher.matches?(:resources => resources).should be false
        end
      end
    end
  end
end

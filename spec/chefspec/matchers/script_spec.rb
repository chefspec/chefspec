require 'spec_helper'

module ChefSpec
  module Matchers
    describe :script do
      %w(bash csh perl python ruby).each do |interpreter|
        describe interpreter do
          let(:matcher) do
            matcher_name = "execute_#{interpreter}_script"
            send(matcher_name, 'foo')
          end

          it "should not match when no resources exist" do
            matcher.matches?(:resources => []).should be false
          end

          it "should match when #{interpreter} resource exists" do
            resources = [{:resource_name => interpreter, :name => 'foo'}]
            matcher.matches?(:resources => resources).should be true
          end

          it "should match when script resource with #{interpreter} interpreter exists" do
            resources = [{:resource_name => 'script', :interpreter => interpreter, :name => 'foo'}]
            matcher.matches?(:resources => resources).should be true
          end

          it "should match when there is another #{interpreter} resource" do
            resources = [{:resource_name => interpreter, :name => 'foo'},
                         {:resource_name => interpreter, :name => 'bar'}]
            matcher.matches?(:resources => resources).should be true
          end

          it "should not match when #{interpreter} resource with another name exists" do
            resources = [{:resource_name => 'bash', :name => 'bar'}]
            matcher.matches?(:resources => resources).should be false
          end

          it "should not match when script resource with another interpreter exists" do
            resources = [{:resource_name => 'script', :interpreter => 'bar', :name => 'foo'}]
            matcher.matches?(:resources => resources).should be false
          end
        end
      end
    end
  end
end

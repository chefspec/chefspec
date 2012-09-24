require 'spec_helper'

module ChefSpec
  module Matchers
    describe :env do
      let(:matcher){create_env('java_home')}
      describe :create_env do
        let(:matcher){create_env('java_home')}
        it "should not match when no resources exist" do
          matcher.matches?({:resources=>[]}).should be false
        end
        it "should match when the env resource exist" do
          matcher.matches?({:resources=>[{:resource_name =>'env',
            :key_name=>'java_home',:action=>:create}]}).should be true
        end
        it "should not match when the env resource with another name exist" do
          matcher.matches?({:resources=>[{:resource_name =>'env',
            :key_name=>'not_java_home'}]}).should be false
        end
      end

      describe :delete_env do
        let(:matcher){delete_env('java_home')}
        it "should not match when no resources exist" do
          matcher.matches?({:resources=>[]}).should be false
        end
        it "should match when the env resource exist and the action is delete" do
          matcher.matches?({:resources=>[{:resource_name =>'env',
            :key_name=>'java_home',:action=>:delete}]}).should be true
        end
        it "should not match when the env resource with another name exist" do
          matcher.matches?({:resources=>[{:resource_name =>'env',
            :key_name=>'not_java_home',:action=>:delete}]}).should be false
        end
      end
      describe :modify_env do
        let(:matcher){modify_env('java_home')}
        it "should not match when no resources exist" do
          matcher.matches?({:resources=>[]}).should be false
        end
        it "should match when the env resource exist" do
          matcher.matches?({:resources=>[{:resource_name =>'env',
            :key_name=>'java_home',:action=>:modify}]}).should be true
        end
        it "should not match when the env resource with modify action but with another name exist" do
          matcher.matches?({:resources=>[{:resource_name =>'env',
            :key_name=>'not_java_home',:action=>:modify}]}).should be false
        end
      end
    end
  end
end

require 'spec_helper'

module ChefSpec
  module Matchers
    describe :user do
      describe "#match" do
        let(:matcher) { create_user 'foo' }
        it "should not match when no resources exist" do
          matcher.matches?({:resources=>[]}).should be false
        end
        it "should not match when there are no user" do
          matcher.matches?({:resources=>[{:resource_name => 'package',:package_name=>'vim-enhanced'}]}).should be false
        end
        it "should match when the user exists" do
          matcher.matches?({:resources=>[{:resource_name => 'user',:username=>'foo',:action=> :create}]}).should be true
        end
        it "should not match when the user name is different" do
          matcher.matches?({:resources=>[{:resource_name => 'user',:username=>'bar'}]}).should be false
        end
      end
    end
  end
end

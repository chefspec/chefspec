require 'spec_helper'

module ChefSpec
  module Matchers
    describe :group do
      describe "#match" do
        let(:matcher) { create_group 'foo' }
        it "should not match when no resources exist" do
          matcher.matches?({:resources=>[]}).should be false
        end
        it "should not match when there are no group" do
          matcher.matches?({:resources=>[{:resource_name => 'package',:package_name=>'vim-enhanced'}]}).should be false
        end
        it "should match when the group exists" do
          matcher.matches?({:resources=>[{:resource_name => 'group',:group_name=>'foo',:action=> :create}]}).should be true
        end
        it "should not match when the group name is different" do
          matcher.matches?({:resources=>[{:resource_name => 'group',:group_name=>'bar'}]}).should be false
        end
      end
    end
  end
end

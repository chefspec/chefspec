require 'spec_helper'

module ChefSpec
  module Matchers
    describe :be_owned_by do
      describe "#match" do
        before(:each) do
          @matcher = be_owned_by('user', 'group')
        end
        it "should not match when the file is nil" do
          @matcher.matches?(nil).should be false
        end
        it "should not match when both the user and group are different" do
          @matcher.matches?({:owner =>'diff_user', :group =>'diff_group'}).should be false
        end
        it "should not match when the owning user is different" do
          @matcher.matches?({:owner =>'diff_user', :group =>'group'}).should be false
        end
        it "should not match when the owning group is different" do
          @matcher.matches?({:owner =>'user', :group =>'diff_group'}).should be false
        end
        it "should match when the user and group match" do
          @matcher.matches?({:owner =>'user', :group =>'group'}).should be true
        end
      end
    end
  end
end
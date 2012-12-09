require 'spec_helper'

module ChefSpec
  module Matchers
    describe :ruby_block do
      let(:matcher){create_ruby_block('sample')}
      it "shouldn't match when no resources exists" do
        matcher.matches?({:resources => []}).should be false
      end
      it "should match when ruby_block resource exists" do
        matcher.matches?({:resources => [{:resource_name => 'ruby_block', :action => :create, :name => 'sample'}]}).should be true
      end
      it "should not match when the ruby_block resource with another name exists" do
        matcher.matches?({:resources => [{:resource_name => 'ruby_block', :action => :create, :name => 'not_sample'}]}).should be false
      end
    end
  end
end
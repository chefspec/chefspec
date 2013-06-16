require 'spec_helper'

module ChefSpec
  module Matchers
    describe :ruby_block do
      context 'with String expectations' do
        let(:matcher) { execute_ruby_block('sample') }
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
      context 'with Regexp expectations' do
        let(:matcher) { execute_ruby_block(/sample/) }
        it "shouldn't match when no resources exists" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should match when an exact matching ruby_block resource exists" do
          matcher.matches?({:resources => [{:resource_name => 'ruby_block', :action => :create, :name => 'sample'}]}).should be true
        end
        it "should match when a matching ruby_block resource exists" do
          matcher.matches?({:resources => [{:resource_name => 'ruby_block', :action => :create, :name => 'still_sample'}]}).should be true
        end
        it "should not match when the ruby_block resource with a non-matching name exists" do
          matcher.matches?({:resources => [{:resource_name => 'ruby_block', :action => :create, :name => 'altogether different'}]}).should be false
        end
      end
    end
  end
end

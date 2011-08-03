require 'spec_helper'

module ChefSpec
  module Matchers
    describe :log do
      describe "#match" do
        before(:each) do
          @matcher = log('Hello World')
        end
        it "should not match when no resources exist" do
          chef_run = {:resources => []}
          @matcher.matches?(chef_run).should be false
        end
        it "should match when the log resource exists" do
          @matcher.matches?({:resources => [{:resource_name => 'log', :name =>'Hello World'}]}).should be true
        end
        it "should not match when only a different log resource exists" do
          @matcher.matches?({:resources => [{:resource_name => 'log', :name =>'Kia Ora'}]}).should be false
        end
        it "should match when there is an another resource present" do
          @matcher.matches?({:resources => [{:resource_name => 'log', :name =>'Hello World'},
            {:resource_name => 'log', :name =>'Hi'}]}).should be true
        end
        it "should not match when the logging whitespace differs" do
          @matcher.matches?({:resources => [{:resource_name => 'log', :name =>'Hello World\t'}]}).should be false
        end
      end
    end
  end
end
require 'spec_helper'

module ChefSpec
  module Matchers
    describe :Hash do
      describe "#has_key?" do
        it "should allow a hash key to be referenced like a method" do
          {'foo' => {'bar' => 'nested_value'}}.foo.bar.should == 'nested_value'
        end
        it "should allow a hash key to be referenced like a method when a symbol" do
          {:foo => {:bar => 'nested_value'}}.foo.bar.should == 'nested_value'
        end
        it "should not swallow errors when the key is not present" do
          expect{{:foo => {:not_bar => 'nested_value'}}.foo.bar}.to raise_error(NoMethodError)
        end
      end
    end
  end
end
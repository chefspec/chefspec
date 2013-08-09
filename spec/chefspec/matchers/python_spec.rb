require 'spec_helper'

module ChefSpec
  module Matchers
    describe :python_pip do
      let(:matcher) { install_python_pip 'foo' }
      it "should not match when no resources exist" do
        matcher.matches?({:resources => []}).should be false
      end
      it "should not match when there is no python package" do
        matcher.matches?({:resources => [{:resource_name => 'package', :name => 'vim-enhanced'}]}).should be false
      end
      it "should match when the python package exists" do
        matcher.matches?({:resources => [{:resource_name => 'python_pip', :name => 'foo', :action=> :install}]}).should be true
      end
      it "should not match when the python package name is different" do
        matcher.matches?({:resources => [{:resource_name => 'python_pip', :name => 'bar'}]}).should be false
      end
    end
  end
end

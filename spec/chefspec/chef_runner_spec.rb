require 'spec_helper'

module ChefSpec
  describe ChefRunner do
    describe "#initialize" do
      it "should create a node for use within the examples" do
        runner = ChefSpec::ChefRunner.new
        runner.node.should_not be_nil
      end
      it "should set the chef cookbook path to a default if not provided" do
        Chef::Config[:cookbook_path] = nil
        ChefSpec::ChefRunner.new
        Chef::Config[:cookbook_path].should_not be_nil
      end
      it "should set the chef cookbook path to any provided value" do
        ChefSpec::ChefRunner.new '/tmp/foo'
        Chef::Config[:cookbook_path].should eql '/tmp/foo'
      end
      it "should alias the real resource actions" do
        ChefSpec::ChefRunner.new
        Chef::Resource::File.method_defined?(:old_run_action).should be
      end
      it "should capture the resources created" do
        runner = ChefSpec::ChefRunner.new
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.run_action(:create)
        runner.resources.size.should == 1
        runner.resources.first.should equal(file)
      end
    end
    describe "#converge" do
      it "should allow a converge with an empty run_list" do
        expect { ChefSpec::ChefRunner.new.converge }.to_not raise_error
      end
      it "should rethrow the exception if a cookbook cannot be found" do
        expect { ChefSpec::ChefRunner.new().converge('non_existent::default') }.to raise_error
      end
    end
    describe "#node" do
      it "should allow attributes to be set on the node" do
        runner = ChefSpec::ChefRunner.new
        runner.node.foo = 'bar'
        runner.node.foo.should eq 'bar'
      end
    end
    describe "#file" do
      it "should not return a resource when the file has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.directory('/tmp/foo.txt').should_not be
      end
      it "should return a resource when the file has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'file', :name => '/tmp/foo.txt'}]
        runner.file('/tmp/foo.txt').should be
      end
    end
    describe "#directory" do
      it "should not return a resource when the directory has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.directory('/tmp').should_not be
      end
      it "should return a resource when the directory has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'directory', :name => '/tmp'}]
        runner.directory('/tmp').should be
      end
    end
  end
end
require 'chefspec'

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
    end
    describe "#converge" do
      before(:each) {@runner = ChefSpec::ChefRunner.new}
      it "should require a run_list to be provided" do
        expect{@runner.converge}.to raise_error(ArgumentError, 'At least one run list item must be provided')
      end
    end
    describe "#node" do
      it "should allow attributes to be set on the node" do
        runner = ChefSpec::ChefRunner.new
        runner.node.foo = 'bar'
        runner.node.foo.should eq 'bar'
      end
    end
  end
end
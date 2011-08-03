require 'spec_helper'

module ChefSpec
  module Matchers
    describe :shared do
      describe "#define_resource_matchers" do
        it "should define one matcher per action for the provided resource" do
          define_resource_matchers([:reverse, :drive, :brake], [:car], :car_name)
          RSpec::Matchers.method_defined?(:reverse_car).should be true
          RSpec::Matchers.method_defined?(:drive_car).should be true
          RSpec::Matchers.method_defined?(:brake_car).should be true
          RSpec::Matchers.method_defined?(:crash_car).should be false
        end
        it "should define one matcher per action for provided resources" do
          define_resource_matchers([:swing], [:golf_club, :cricket_bat], :name)
          RSpec::Matchers.method_defined?(:swing_golf_club).should be true
          RSpec::Matchers.method_defined?(:swing_cricket_bat).should be true
        end
        it "should define a matcher that matches on resource type, name and action" do
          define_resource_matchers([:tail], [:log], :name)
          tail_log('Hello').matches?({:resources => [{:resource_name => 'log', :action => 'tail', :name => 'Hello'}]}).should be true
        end
        it "should define a should failure message" do
          define_resource_matchers([:climb], [:mountain], :name)
          climb_mountain('everest').failure_message_for_should.should == "No mountain resource named 'everest' with action :climb found."
        end
        it "should define a should_not failure message" do
          define_resource_matchers([:climb], [:mountain], :name)
          climb_mountain('Kilimanjaro').failure_message_for_should_not.should == "Found mountain resource named 'Kilimanjaro' with action :climb that should not exist."
        end
      end
    end
  end
end
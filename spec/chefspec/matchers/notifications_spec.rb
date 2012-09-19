require 'spec_helper'

module ChefSpec
  module Matchers
    describe :notifications do
      describe "#notify " do
        let(:matcher){notify "service[nginx]" ,:restart}
        it "should define one notify matcher per resource" do
          matcher_defined?(:notify).should be_true 
        end
        it "should match a genuine notification from a resource" do
          fake_resource = fake_resource_with_notification('nginx','service','restart')
          matcher.matches?(fake_resource).should be_true
        end
        it "should not match a notification from a resource that does not notify the intended resource" do
          fake_resource = fake_resource_with_notification('nginx','service','stop')
          matcher.matches?(fake_resource).should be_false
        end

        def fake_resource_with_notification(name,type,action)
          notified_resource = double('notified-resource')
          notified_resource.stub(:resource_name).and_return(type)
          notified_resource.stub(:name).and_return(name)
          notified_resource_struct = double('notified-resource-struct')
          notified_resource_struct.stub(:resource).and_return(notified_resource)
          notified_resource_struct.stub(:action).and_return(action)
          fake_resource = double("resource")
          fake_resource.stub(:delayed_notifications).and_return([notified_resource_struct])
          fake_resource.stub(:immediate_notifications).and_return([])
          fake_resource
        end
      end
    end
  end
end

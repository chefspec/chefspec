require 'spec_helper'

module ChefSpec
  module Matchers
    describe :service do
      describe "#set_service_to_start_on_boot" do
        before(:each) do
          @matcher = set_service_to_start_on_boot('food')
        end
        it "should not match when no resources exist" do
          chef_run = {:resources => []}
          @matcher.matches?(chef_run).should be false
        end
        it "should not match if no service resource is declared" do
          chef_run = {:resources => [{:resource_name => 'log', :name => 'Installing service...'}]}
          @matcher.matches?(chef_run).should be false
        end
        it "should not match if a different service is declared" do
          chef_run = {:resources => [{:resource_name => 'service', :service_name => 'sendmail', :action => [:start, :enable]}]}
          @matcher.matches?(chef_run).should be false
        end
        it "should not match if the service is set to start but not enabled" do
          chef_run = {:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:start]}]}
          @matcher.matches?(chef_run).should be false
        end
        it "should match if the service is enabled" do
          chef_run = {:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:enable]}]}
          @matcher.matches?(chef_run).should be true
        end
        it "should match if the service is enabled amongst other actions" do
          chef_run = {:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:stop, :enable, :start, :restart]}]}
          @matcher.matches?(chef_run).should be true
        end
      end
    end
  end
end
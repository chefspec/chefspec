require 'spec_helper'

module ChefSpec
  module Matchers
    describe :service do
      describe "#set_service_to_start_on_boot" do
        let(:matcher) { matcher = set_service_to_start_on_boot('food') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match if no service resource is declared" do
          matcher.matches?({:resources => [{:resource_name => 'log', :name => 'Installing service...'}]}).should be false
        end
        it "should not match if a different service is declared" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'sendmail', :action => [:start, :enable]}]}).should be false
        end
        it "should not match if the service is set to start but not enabled" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:start]}]}).should be false
        end
        it "should match if the service is enabled" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:enable]}]}).should be true
        end
        it "should match if the service is enabled amongst other actions" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:stop, :enable, :start, :restart]}]}).should be true
        end
      end

      describe "#set_service_to_not_start_on_boot" do
        let(:matcher) { matcher = set_service_to_not_start_on_boot('food') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should not match if no service resource is declared" do
          matcher.matches?({:resources => [{:resource_name => 'log', :name => 'Installing service...'}]}).should be false
        end
        it "should not match if a different service is declared" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'sendmail', :action => [:stop, :disable]}]}).should be false
        end
        it "should not match if the service is set to start but not enabled" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:start]}]}).should be false
        end
        it "should match if the service is disabled" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:disable]}]}).should be true
        end
        it "should match if the service is disabled amongst other actions" do
          matcher.matches?({:resources => [{:resource_name => 'service', :service_name => 'food', :action => [:stop, :disable, :start, :restart]}]}).should be true
        end
      end
    end
  end
end

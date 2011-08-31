require 'spec_helper'

module ChefSpec
  module Matchers
    describe :execute_command do
      describe "#match" do
        let(:matcher) { execute_command('ls') }
        it "should not match when no resources exist" do
          chef_run = {:resources => []}
          matcher.matches?(chef_run).should be false
        end
        it "should match when the execute resource exists" do
          matcher.matches?({:resources => [{:resource_name => 'execute', :command =>'ls'}]}).should be true
        end
        it "should not match when an execute resource exists for a different command" do
          matcher.matches?({:resources => [{:resource_name => 'execute', :command =>'dir'}]}).should be false
        end
        it "should match when there is another execute command" do
          matcher.matches?({:resources => [{:resource_name => 'execute', :command =>'dir'},
            {:resource_name => 'execute', :command =>'ls'}]}).should be true
        end
        it "should not match when the command whitespace differs" do
          matcher.matches?({:resources => [{:resource_name => 'execute', :command =>'ls '}]}).should be false
        end
      end
    end
  end
end

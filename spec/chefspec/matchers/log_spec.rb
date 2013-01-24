require 'spec_helper'

module ChefSpec
  module Matchers
    describe :log do
      describe "#match" do
        let(:matcher) { log('Hello World') }
        it "should not match when no resources exist" do
          matcher.matches?({:resources => []}).should be false
        end
        it "should match when the log resource exists" do
          matcher.matches?({:resources => [fake_log_resource('Hello World')]}).should be true
        end
        it "should not match when only a different log resource exists" do
          matcher.matches?({:resources => [fake_log_resource('Kia Ora')]}).should be false
        end
        it "should match when there is an another resource present" do
          matcher.matches?({:resources => [fake_log_resource('Hello World'),
            fake_log_resource('Hi')]}).should be true
        end
        it "should not match when the logging whitespace differs" do
          matcher.matches?({:resources => [fake_log_resource('Hello World\t')]}).should be false
        end
        it "should prefer message attribute over name attribute" do
          matcher.matches?({:resources => [fake_log_resource('Hola Mundo', 'Hello World')]}).should be true
          matcher.matches?({:resources => [fake_log_resource('Hello World', 'Hola Mundo')]}).should be false
        end
        it "should fallback using name attribute for older Chef versions" do
          matcher.matches?({:resources => [fake_old_log_resource('Hello World')]}).should be true
        end

        context "regexp" do
          let(:matcher) { log(/^Hel+/) }
          it "should match when a matching log resource exists" do
            matcher.matches?({:resources => [fake_log_resource('Hello World')]}).should be true
          end
          it "should not match when only a different log resource exists" do
            matcher.matches?({:resources => [fake_log_resource('Hola Mundo')]}).should be false
          end
        end

        def fake_log_resource(name, message = nil)
          fake_resource = fake_old_log_resource(name)
          fake_resource.stub(:message).and_return(message || name)
          fake_resource
        end

        def fake_old_log_resource(name)
          fake_resource = double('log resource')
          fake_resource.stub(:resource_name).and_return('log')
          fake_resource.stub(:name).and_return(name)
          fake_resource
        end
      end
    end
  end
end

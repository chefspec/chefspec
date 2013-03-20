require 'spec_helper'

module ChefSpec
  module Matchers
    describe :script do
      %w(bash csh perl python ruby).each do |interpreter|
        describe interpreter do
          let(:matcher) do
            matcher_name = "execute_#{interpreter}_script"
            send(matcher_name, 'foo')
          end

          it "should not match when no resources exist" do
            matcher.matches?(:resources => []).should be false
          end

          it "should match when #{interpreter} resource exists" do
            resources = [{:resource_name => interpreter, :name => 'foo'}]
            matcher.matches?(:resources => resources).should be true
          end

          it "should match when script resource with #{interpreter} interpreter exists" do
            resources = [{:resource_name => 'script', :interpreter => interpreter, :name => 'foo'}]
            matcher.matches?(:resources => resources).should be true
          end

          it "should match when there is another #{interpreter} resource" do
            resources = [{:resource_name => interpreter, :name => 'foo'},
                         {:resource_name => interpreter, :name => 'bar'}]
            matcher.matches?(:resources => resources).should be true
          end

          it "should not match when #{interpreter} resource with another name exists" do
            resources = [{:resource_name => 'bash', :name => 'bar'}]
            matcher.matches?(:resources => resources).should be false
          end

          it "should not match when script resource with another interpreter exists" do
            resources = [{:resource_name => 'script', :interpreter => 'bar', :name => 'foo'}]
            matcher.matches?(:resources => resources).should be false
          end

          describe "#with" do
            before do
              @interpreter = interpreter
            end

            let(:matcher) do
              matcher_name = "execute_#{interpreter}_script"
              send(matcher_name, 'foo').with(:user => 'foo', :cwd => '/tmp')
            end

            def do_match(attributes)
              default_attributes = {:resource_name => 'script',
                                    :interpreter => @interpreter,
                                    :name => 'foo',
                                    :user => 'foo',
                                    :cwd => '/tmp'}
              matcher.matches?({:resources => [default_attributes.merge(attributes)]})
            end

            it "does not match when one attributes differs" do
              expect(do_match(:user => 'bar')).to be false
            end

            it "does match when all attributes are equal" do
              expect(do_match({})).to be true
            end
          end
        end
      end
    end
  end
end

require 'spec_helper'

module ChefSpec
  module Matchers
    describe :script do
      %w(bash csh perl python ruby).each do |interpreter|
        describe interpreter do
          let(:matcher) { send("execute_#{interpreter}_script", 'foo') }

          it "does not match when no #{interpreter} resources exist" do
            expect(matcher).to_not be_matches({ resources: [] })
          end

          it "matches when #{interpreter} resource exists" do
            expect(matcher).to be_matches({
              node: {},
              resources: [{
                resource_name: interpreter,
                name: 'foo'
              }]
            })
          end

          it "matches when script resource with #{interpreter} interpreter exists" do
            expect(matcher).to be_matches({
              node: {},
              resources: [{
                resource_name: 'script',
                interpreter: interpreter,
                name: 'foo'
              }]
            })
          end

          it "matches when there is another #{interpreter} resource" do
            expect(matcher).to be_matches({
              node: {},
              resources: [{
                resource_name: interpreter,
                name: 'foo'
              }, {
                resource_name: interpreter,
                name: 'bar'
              }]
            })
          end

          it "does not match when #{interpreter} resource with another name exists" do
            expect(matcher).to_not be_matches({
              node: {},
              resources: [{
                resource_name: 'bash',
                name: 'bar'
              }]
            })
          end

          it "does not match when script resource with another interpreter exists" do
            expect(matcher).to_not be_matches({
              node: {},
              resources: [{
                resource_name: 'script',
                interpreter: 'bar',
                name: 'foo'
              }]
            })
          end

          describe '#with' do
            let(:matcher) { send("execute_#{interpreter}_script", 'foo').with(user: 'foo', cwd: '/tmp') }
            let(:chef_run) do
              {
                node: {},
                resources: [{
                  resource_name: 'script',
                  interpreter: interpreter,
                  name: 'foo',
                  user: 'foo',
                  cwd: '/tmp'
                }]
              }
            end

            it 'does not match when one attributes differs' do
              chef_run[:resources].first[:user] = 'bar'
              expect(matcher).to_not be_matches(chef_run)
            end

            it 'does match when all attributes are equal' do
              expect(matcher).to be_matches(chef_run)
            end
          end
        end
      end
    end
  end
end

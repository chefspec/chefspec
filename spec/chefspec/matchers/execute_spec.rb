require 'spec_helper'

module ChefSpec
  module Matchers
    describe :execute_command do
      describe '#match' do
        ['ls', /^ls$/].each do |key|
          context "when the command to match is a #{key.inspect}" do
            let(:matcher) { execute_command(key) }
            let(:chef_run) do
              {
                node: {},
                resources: [{
                  resource_name: 'execute',
                  command: 'ls'
                }]
              }
            end

            it 'does not match when no resources exist' do
              expect(matcher).to_not be_matches({ resources: [] })
            end

            it 'matches when the execute resource exists' do
              expect(matcher).to be_matches(chef_run)
            end

            it 'does not match when an execute resource exists for a different command' do
              chef_run[:resources].first[:command] = 'dir'
              expect(matcher).to_not be_matches(chef_run)
            end

            it 'matches when there is another execute command' do
              chef_run[:resources].push({ resource_name: 'execute', command: 'dir' })
              expect(matcher).to be_matches(chef_run)
            end

            it 'does not match when the command whitespace differs' do
              chef_run[:resources].first[:command] = 'ls '
              expect(matcher).to_not be_matches(chef_run)
            end
          end
        end

        describe '#with' do
          let(:matcher) { execute_command('ls').with(user: 'foo', cwd: '/tmp') }
          let(:chef_run) do
            {
              node: {},
              resources: [{
                resource_name: 'execute',
                command: 'ls',
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

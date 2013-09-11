require 'spec_helper'

module ChefSpec
  module Matchers
    describe :log do
      describe '#match' do
        let(:matcher) { log('Hello World') }
        let(:chef_run) do
          {
            node: {},
            resources: [{
              resource_name: 'log',
              name: 'Hello World'
            }]
          }
        end

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'matches when the log resource exists' do
          expect(matcher).to be_matches(chef_run)
        end

        it 'does not match when only a different log resource exists' do
          chef_run[:resources].first[:name] = 'bacon'
          expect(matcher).to_not be_matches(chef_run)
        end

        it 'matches when there is an another resource present' do
          chef_run[:resources].push({ resource_name: 'log', name: 'bacon' })
          expect(matcher).to be_matches(chef_run)
        end

        it 'does not match when the logging whitespace differs' do
          chef_run[:resources].first[:name] = 'Hello World '
          expect(matcher).to_not be_matches(chef_run)
        end

        it 'prefers message attribute over name attribute' do
          chef_run[:resources].first[:name] = 'log_some_action'
          chef_run[:resources].first[:message] = 'Hello World'
          expect(matcher).to be_matches(chef_run)
        end

        context 'regexp' do
          let(:matcher) { log(/^Hel+/) }

          it 'matches when a matching log resource exists' do
            expect(matcher).to be_matches(chef_run)
          end

          it 'does not match when only a different log resource exists' do
            chef_run[:resources].first[:name] = 'bacon'
            expect(matcher).to_not be_matches(chef_run)
          end
        end
      end

      describe '#with' do
        let(:matcher) { log('Hello World').with(level: :info) }
        let(:chef_run) do
          {
            node: {},
            resources: [{
              resource_name: 'log',
              name: 'Hello World',
              level: :info
            }]
          }
        end

        it 'does not match when one attributes differs' do
          chef_run[:resources].first[:level] = :fatal
          expect(matcher).to_not be_matches(chef_run)
        end

        it 'matches when all attributes are equal' do
          expect(matcher).to be_matches(chef_run)
        end
      end
    end
  end
end

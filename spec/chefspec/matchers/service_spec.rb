require 'spec_helper'

module ChefSpec
  module Matchers
    describe :service do
      describe '#set_service_to_start_on_boot' do
        let(:matcher) { set_service_to_start_on_boot('food') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match if no service resource is declared' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'log',
              name: 'Installing service...'
            }]
          })
        end

        it 'does not match if a different service is declared' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'sendmail',
              action: [:start, :enable]
            }]
          })
        end

        it 'does not match if the service is set to start but not enabled' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'food',
              action: [:start]
            }]
          })
        end

        it 'matches if the service is enabled' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'food',
              action: [:enable]
            }]
          })
        end

        it 'matches if the service is enabled amongst other actions' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'food',
              action: [:stop, :enable, :start, :restart]
            }]
          })
        end
      end

      describe '#set_service_to_not_start_on_boot' do
        let(:matcher) { set_service_to_not_start_on_boot('food') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match if no service resource is declared' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'log',
              name: 'Installing service...'
            }]
          })
        end

        it 'does not match if a different service is declared' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'sendmail',
              action: [:stop, :disable]
            }]
          })
        end

        it 'does not match if the service is set to start but not enabled' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'food',
              action: [:start]
            }]
          })
        end

        it 'matches if the service is disabled' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'food',
              action: [:disable]
            }]
          })
        end

        it 'matches if the service is disabled amongst other actions' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'service',
              service_name: 'food',
              action: [:stop, :disable, :start, :restart]
            }]
          })
        end
      end
    end
  end
end

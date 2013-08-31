require 'spec_helper'

module ChefSpec
  module Matchers
    describe :notifications do
      describe '#notify' do
        let(:matcher) { notify('service[nginx]', :restart) }

        it 'defines one notify matcher per resource' do
          expect(matcher_defined?(:notify)).to be_true
        end

        it 'matches a genuine notification from a resource' do
          expect(matcher).to be_matches(fake_resource_with_notification('nginx', 'service', 'restart'))
        end

        it 'does not match a notification from a resource that does not notify the intended resource' do
          expect(matcher).to_not be_matches(fake_resource_with_notification('nginx', 'service', 'stop'))
        end

        context 'regex' do
          let(:matcher) { notify('service[nginx[v1.2.3]]', :restart) }

          it 'allows brackets in the name' do
            expect(matcher).to be_matches(fake_resource_with_notification('nginx[v1.2.3]', 'service', 'restart'))
          end
        end

        def fake_resource_with_notification(name, type, action)
          notified_resource = double('notified-resource', resource_name: type, name: name)
          notified_resource_struct = double('notified-resource-struct', resource: notified_resource, action: action)
          return double('resource', delayed_notifications: [notified_resource_struct], immediate_notifications: [])
        end
      end
    end
  end
end

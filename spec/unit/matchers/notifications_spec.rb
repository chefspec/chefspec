require 'spec_helper'

module ChefSpec
  module Matchers
    describe :notifications do
      describe '#notify' do
        let(:matcher) { notify('service[nginx]') }

        it 'defines one notify matcher per resource' do
          expect(matcher_defined?(:notify)).to be_true
        end

        it 'matches a notification from a resource' do
          expect(matcher).to be_matches(fake_notification('service[nginx]', :restart))
        end

        it 'does not match when the resource does not notify' do
          expect(matcher).to_not be_matches(fake_notification('service[apache2]]', :restart))
        end

        describe '#to' do
          let(:matcher) { notify('service[nginx]').to(:restart) }

          it 'matches when the resource exists with the given action' do
            expect(matcher).to be_matches(fake_notification('service[nginx]', :restart))
          end

          it 'does not match when the resource action is different' do
            expect(matcher).to_not be_matches(fake_notification('service[nginx]', :stop))
          end
        end

        describe '#immediately' do
          let(:matcher) { notify('service[nginx]').immediately }

          it 'matches when the reource exists and notifies immediately' do
            expect(matcher).to be_matches(fake_notification('service[nginx]', :start, :immediately))
          end

          it 'does matches when the reource exists and does not notify immediately' do
            expect(matcher).to_not be_matches(fake_notification('service[nginx]', :start, :delayed))
          end
        end

        describe '#delayed' do
          let(:matcher) { notify('service[nginx]').delayed }

          it 'matches when the reource exists and notifies delayed' do
            expect(matcher).to be_matches(fake_notification('service[nginx]', :start, :delayed))
          end

          it 'does matches when the reource exists and does not notify delayed' do
            expect(matcher).to_not be_matches(fake_notification('service[nginx]', :start, :immediately))
          end
        end

        def fake_notification(thing, action, timing = :delayed)
          thing.match(/^([^\[]*)\[(.*)\]$/)
          type, name = $1, $2

          notified = double('notified', resource_name: type, name: name)
          struct = double('struct', resource: notified, action: action)
          resource = double('resource')

          if timing == :immediately
            resource.stub(:delayed_notifications) { [] }
            resource.stub(:immediate_notifications) { [struct] }
          else
            resource.stub(:delayed_notifications) { [struct] }
            resource.stub(:immediate_notifications) { [] }
          end

          return resource
        end
      end
    end
  end
end

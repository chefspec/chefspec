require 'spec_helper'

module ChefSpec
  describe Matchers do
    describe '.define_resource_matchers' do
      it 'defines one matcher per action' do
        described_class.define_resource_matchers([:brake, :drive, :reverse], [:car])

        expect(matcher_defined?(:brake_car)).to be_true
        expect(matcher_defined?(:drive_car)).to be_true
        expect(matcher_defined?(:reverse_car)).to be_true
      end

      it 'defines one matcher per resource' do
        described_class.define_resource_matchers([:swing], [:golf_club, :cricket_bat])

        expect(matcher_defined?(:swing_golf_club)).to be_true
        expect(matcher_defined?(:swing_cricket_bat)).to be_true
      end

      it 'defines a shortcut method on the Chef Runner' do
        described_class.define_resource_matchers([:eat], [:bacon])

        expect(ChefSpec::Runner).to be_method_defined(:bacon)
      end

      describe '#matches' do
        before do
          described_class.define_resource_matchers([:tail], [:log])
        end

        let(:chef_run) do
          {
            node: {},
            resources: {
              'log[Hello]' => {
                resource_name: 'log',
                action:        'tail',
                identity:      'Hello',
                name:          'Hello',
                mode:          :info,
                max_size:      4,
                comment:       'Managed by Chef',
              }
            }
          }
        end

        it 'does not match when the name does not match' do
          expect(tail_log('Not Real')).to_not be_matches(chef_run)
        end

        it 'does not match when the name does not match when a regex' do
          expect(tail_log(/^Not(.+)$/)).to_not be_matches(chef_run)
        end

        it 'matches on resource name and identity' do
          expect(tail_log('Hello')).to be_matches(chef_run)
        end

        it 'matches on resource_name and identity when a regex' do
          expect(tail_log(/He[l]+o/)).to be_matches(chef_run)
        end

        it 'defines a failure_message_for_should' do
          expect(tail_log('Hello').failure_message_for_should).to eq("expected 'log[Hello]' with action ':tail' to be in Chef run")
        end

        it 'defines a failure_message_for_should_not' do
          expect(tail_log('Hello').failure_message_for_should_not).to eq("expected 'log[Hello]' matching 'Hello' with action ':tail' to not be in Chef run")
        end

        describe '#with' do
          let(:matcher) { tail_log('Hello').with(mode: :info, max_size: (3..5), comment: /Managed|b/) }

          it 'does not match when an attribute is different' do
            chef_run[:resources]['log[Hello]'][:mode] = :warn
            expect(matcher).to_not be_matches(chef_run)
          end

          it 'matches when additional attributes are present' do
            chef_run[:resources]['log[Hello]'][:ttl] = 300
            expect(matcher).to be_matches(chef_run)
          end

          it 'matches when it is an exact match' do
            expect(matcher).to be_matches(chef_run)
          end
        end
      end
    end
  end
end

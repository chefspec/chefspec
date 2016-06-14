require 'spec_helper'

describe ChefSpec::Matchers::SubscribesMatcher do
  subject { described_class.new('execute[install]') }
  let(:runner) { double('runner', find_resource: nil) }
  let(:run_context) { double('run_context', node: node) }
  let(:node) { double('node', runner: runner) }
  let(:package) do
    double('package',
      name: 'package',
      to_s: 'package[foo]',
      run_context: run_context,
    )
  end

  context 'when no resource is found' do
    describe '#failure_message' do
      it 'has the right value' do
        subject.matches?(package)
        expect(subject.failure_message)
          .to include %|expected _something_ to notify "package[foo]", but the _something_ you gave me was nil! If you are running a test like:|
      end
    end
  end

  context 'when the resource exists' do
    let(:execute) do
      double('execute',
        name: 'execute',
        to_s: 'execute[install]',
        immediate_notifications: [],
        delayed_notifications: [],
        before_notifications: []
      )
    end

    before do
      allow(runner).to receive(:find_resource).and_return(execute)
    end

    describe '#failure_message' do
      it 'has the right value' do
        subject.matches?(package)
        expect(subject.failure_message)
          .to include %|expected "execute[install]" to notify "package[foo]", but did not.|
      end
    end

    describe '#failure_message_when_negated' do
      it 'has the right value' do
        subject.matches?(package)
        expect(subject.failure_message_when_negated)
          .to eq %|expected "execute[install]" to not notify "package[foo]", but it did.|
      end
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(package)
      expect(subject.description)
        .to eq %|notify "package[foo]"|
    end
  end
end

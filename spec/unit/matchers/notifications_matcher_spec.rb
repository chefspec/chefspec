require 'spec_helper'

describe ChefSpec::Matchers::NotificationsMatcher do
  subject { described_class.new('execute[install]') }
  let(:package) do
    double('package',
      name: 'package',
      to_s: 'package[foo]',
      is_a?: true,
      performed_action?: true,
      immediate_notifications: [],
      delayed_notifications: [],
      before_notifications: []
    )
  end

  describe '#failure_message' do
    it 'has the right value' do
      subject.matches?(package)
      expect(subject.failure_message)
        .to include %|expected "package[foo]" to notify "execute[install]", but did not.|
    end
  end

  describe '#failure_message_when_negated' do
    it 'has the right value' do
      subject.matches?(package)
      expect(subject.failure_message_when_negated)
        .to eq %|expected "package[foo]" to not notify "execute[install]", but it did.|
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(package)
      expect(subject.description)
        .to eq %|notify "execute[install]"|
    end
  end
end

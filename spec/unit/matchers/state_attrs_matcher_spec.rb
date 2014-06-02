require 'spec_helper'

describe ChefSpec::Matchers::StateAttrsMatcher do
  subject { described_class.new([:a, :b]) }

  context 'when the resource does not exist' do
    let(:resource) { nil }
    before { subject.matches?(resource) }

    it 'does not match' do
      expect(subject).to_not be_matches(resource)
    end

    it 'has the correct description' do
      expect(subject.description).to eq('have state attributes [:a, :b]')
    end

    it 'has the correct failure message for should' do
      expect(subject.failure_message).to include <<-EOH.gsub(/^ {8}/, '')
        expected _something_ to have state attributes, but the _something_ you gave me was nil!
        Ensure the resource exists before making assertions:

          expect(resource).to be
      EOH
    end

    it 'has the correct failure message for should not' do
      expect(subject.failure_message_when_negated).to include <<-EOH.gsub(/^ {8}/, '')
        expected _something_ to not have state attributes, but the _something_ you gave me was nil!
        Ensure the resource exists before making assertions:

          expect(resource).to be
      EOH
    end
  end

  context 'when the resource exists' do
    let(:klass) { double('class', state_attrs: [:a, :b]) }
    let(:resource) { double('resource', class: klass) }
    before { subject.matches?(resource) }

    it 'has the correct description' do
      expect(subject.description).to eq('have state attributes [:a, :b]')
    end

    it 'has the correct failure message for should' do
      expect(subject.failure_message).to eq('expected [:a, :b] to equal [:a, :b]')
    end

    it 'has the correct failure message for should not' do
      expect(subject.failure_message_when_negated).to eq('expected [:a, :b] to not equal [:a, :b]')
    end

    it 'matches when the state attributes are correct' do
      expect(subject).to be_matches(resource)
    end

    it 'does not match when the state attributes are incorrect' do
      allow(klass).to receive(:state_attrs).and_return([:c, :d])
      expect(subject).to_not be_matches(resource)
    end

    it 'does not match when partial state attribute are incorrect' do
      allow(klass).to receive(:state_attrs).and_return([:b, :c])
      expect(subject).to_not be_matches(resource)
    end
  end
end

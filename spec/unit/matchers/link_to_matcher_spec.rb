require 'spec_helper'

describe ChefSpec::Matchers::LinkToMatcher do
  let(:from) { '/var/www' }
  let(:to)   { '/var/html' }
  let(:link) do
    Chef::Resource::Link.new(from).tap do |link|
      link.to(to)
      link.perform_action(:create)
    end
  end
  subject { described_class.new(to) }

  describe '#failure_message' do
    it 'has the right value' do
      subject.matches?(link)
      expect(subject.failure_message)
        .to eq(%Q(expected "link[#{from}]" to link to "#{to}" but was "#{to}"))
    end
  end

  describe '#failure_message_when_negated' do
    it 'has the right value' do
      subject.matches?(link)
      expect(subject.failure_message_when_negated)
        .to eq(%Q(expected "link[#{from}]" to not link to "#{to}"))
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(link)
      expect(subject.description).to eq(%Q(link to "#{to}"))
    end
  end

  context 'when the link is correct' do
    it 'matches' do
      expect(subject.matches?(link)).to be_truthy
    end

    it 'adds the link to the coverage report' do
      expect(ChefSpec::Coverage).to receive(:cover!).with(link)
      subject.matches?(link)
    end
  end

  context 'when the link is not correct' do
    subject { described_class.new('/nope/bad/path/bro') }

    it 'does not match' do
      expect(subject.matches?(link)).to be_falsy
    end
  end
end

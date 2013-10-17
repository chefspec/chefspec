require 'spec_helper'

describe ChefSpec::Matchers::LinkToMatcher do
  let(:path) { '/var/www' }
  let(:link) { double('link', to: path, to_s: "link[#{path}]", is_a?: true, performed_action?: true) }
  subject { described_class.new(path) }

  describe '#failure_message_for_should' do
    it 'has the right value' do
      subject.matches?(link)
      expect(subject.failure_message_for_should)
        .to eq(%Q(expected 'link[#{path}]' to link to '#{path}' but was '#{path}'))
    end
  end

  describe '#failure_message_for_should_not' do
    it 'has the right value' do
      subject.matches?(link)
      expect(subject.failure_message_for_should_not)
        .to eq(%Q(expected 'link[#{path}]' to not link to '#{path}'))
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(link)
      expect(subject.description).to eq(%Q(link to '#{path}'))
    end
  end

  it 'matches when the link is correct' do
    expect(subject.matches?(link)).to be_true
  end

  it 'does not match when the link is incorrect' do
    failure = described_class.new('nope')
    expect(failure.matches?(link)).to be_false
  end
end

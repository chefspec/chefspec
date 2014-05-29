require 'spec_helper'

describe ChefSpec::Matchers::IncludeResourceMatcher do
  let(:my_resource) { double('my_resource', resource_name: :my_resource) }
  let(:my_other_resource) { double('my_other_resource', resource_name: :my_other_resource) }

  let(:chef_run) { double('chef run', resource_collection: [ my_resource, my_other_resource ]) }
  subject { described_class.new('my_resource') }

  describe '#failure_message_for_should' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.failure_message_for_should)
        .to eq(%q(expected my_resource my_other_resource to include my_resource))
    end
  end

  describe '#failure_message_for_should_not' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.failure_message_for_should_not)
        .to eq(%q(expected my_resource my_other_resource to not include my_resource))
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.description).to eq(%q(include resource my_resource))
    end
  end

  it 'matches when the resource is included' do
    expect(subject.matches?(chef_run)).to be_true
  end

  it 'does not match when the resource is not included' do
    failure = described_class.new('nope')
    expect(failure.matches?(chef_run)).to be_false
  end
end

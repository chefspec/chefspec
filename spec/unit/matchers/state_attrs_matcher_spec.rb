require 'spec_helper'

describe ChefSpec::Matchers::StateAttrsMatcher do
  subject { described_class.new([:a, :b]) }

  context 'when the resource does not exist' do
    let(:resource) { nil }
    before { subject.matches?(resource) }

    it 'does not match' do
      expect(subject).to_not be_matches(resource)
    end

    its(:description) { should eq('have state attributes [:a, :b]') }

    its(:failure_message_for_should) do
      should eq "expected _something_ to have state attributes, but " \
        "the _something_ you gave me was nil!" \
        "\n" \
        "Ensure the resource exists before making assertions:" \
        "\n\n" \
        "  expect(resource).to be" \
        "\n "
    end

    its(:failure_message_for_should_not) do
      should eq "expected _something_ to not have state attributes, but " \
        "the _something_ you gave me was nil!" \
        "\n" \
        "Ensure the resource exists before making assertions:" \
        "\n\n" \
        "  expect(resource).to be" \
        "\n "
    end
  end

  context 'when the resource exists' do
    let(:klass) { double('class', state_attrs: [:a, :b]) }
    let(:resource) { double('resource', class: klass) }
    before { subject.matches?(resource) }

    its(:description) { should eq('have state attributes [:a, :b]') }
    its(:failure_message_for_should) do
      should eq('expected [:a, :b] to equal [:a, :b]')
    end
    its(:failure_message_for_should_not) do
      should eq('expected [:a, :b] to not equal [:a, :b]')
    end

    it 'matches when the state attributes are correct' do
      expect(subject).to be_matches(resource)
    end

    it 'does not match when the state attributes are incorrect' do
      klass.stub(:state_attrs).and_return([:c, :d])
      expect(subject).to_not be_matches(resource)
    end

    it 'does not match when partial state attribute are incorrect' do
      klass.stub(:state_attrs).and_return([:b, :c])
      expect(subject).to_not be_matches(resource)
    end
  end
end

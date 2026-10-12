require "spec_helper"

describe ChefSpec::Matchers::DoNothingMatcher do
  subject { described_class.new }
  let(:resource) { Chef::Resource::Execute.new("run my thing") }

  describe "#matches?" do
    it "does not match when the resource is nil" do
      expect(subject.matches?(nil)).to be false
    end

    it "matches a resource that performed no actions" do
      allow(resource).to receive(:performed_actions).and_return([])
      expect(subject.matches?(resource)).to be true
    end

    it "matches a resource that only performed :nothing" do
      allow(resource).to receive(:performed_actions).and_return([:nothing])
      expect(subject.matches?(resource)).to be true
    end

    it "does not match a resource that performed a real action" do
      allow(resource).to receive(:performed_actions).and_return([:run])
      expect(subject.matches?(resource)).to be false
    end
  end

  describe "#description" do
    it "has the right value" do
      expect(subject.description).to eq("do nothing")
    end
  end

  describe "#failure_message" do
    it "lists the actions that were performed" do
      allow(resource).to receive(:performed_actions).and_return([:run])
      subject.matches?(resource)
      expect(subject.failure_message).to include("to do nothing", ":run")
    end

    it "explains when the resource was nil" do
      subject.matches?(nil)
      expect(subject.failure_message).to include("you gave me was nil")
    end
  end

  describe "#failure_message_when_negated" do
    it "explains that no actions were performed" do
      allow(resource).to receive(:performed_actions).and_return([])
      subject.matches?(resource)
      expect(subject.failure_message_when_negated).to include("to do something")
    end
  end
end

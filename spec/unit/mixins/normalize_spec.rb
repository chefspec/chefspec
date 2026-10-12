require "spec_helper"

describe ChefSpec::Normalize do
  subject(:normalizer) { Class.new { include ChefSpec::Normalize }.new }

  describe "#resource_name" do
    it "returns a symbol for a plain string" do
      expect(normalizer.resource_name("file")).to eq(:file)
    end

    it "converts dashes to underscores" do
      expect(normalizer.resource_name("my-resource")).to eq(:my_resource)
    end

    it "prefers declared_type when present" do
      thing = double(declared_type: "yum_repository")
      expect(normalizer.resource_name(thing)).to eq(:yum_repository)
    end

    it "normalizes dashes in a declared_type" do
      thing = double(declared_type: "yum-repository")
      expect(normalizer.resource_name(thing)).to eq(:yum_repository)
    end

    it "falls back to resource_name when declared_type is nil" do
      thing = double(declared_type: nil, resource_name: "template")
      expect(normalizer.resource_name(thing)).to eq(:template)
    end
  end
end

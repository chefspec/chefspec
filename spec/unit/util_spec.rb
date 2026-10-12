require "spec_helper"

describe ChefSpec::Util do
  describe "#underscore" do
    it "converts CamelCase to snake_case" do
      expect(described_class.underscore("CamelCase")).to eq("camel_case")
    end

    it "converts namespaced constants to slash-separated paths" do
      expect(described_class.underscore("ChefSpec::SoloRunner")).to eq("chef_spec/solo_runner")
    end

    it "handles runs of capitals (acronyms)" do
      expect(described_class.underscore("HTTPRequest")).to eq("http_request")
    end

    it "converts dashes to underscores" do
      expect(described_class.underscore("my-cookbook")).to eq("my_cookbook")
    end
  end

  describe "#camelize" do
    it "converts snake_case to CamelCase" do
      expect(described_class.camelize("camel_case")).to eq("CamelCase")
    end

    it "leaves a single word capitalized" do
      expect(described_class.camelize("runner")).to eq("Runner")
    end
  end

  describe "#truncate" do
    it "returns the string unchanged when it is within the limit" do
      expect(described_class.truncate("short")).to eq("short")
    end

    it "truncates with a trailing ellipsis when over the limit" do
      expect(described_class.truncate("#{"x" * 40}", length: 10)).to eq("xxxxxxxx...")
    end

    it "defaults to a length of 30" do
      expect(described_class.truncate("y" * 40)).to eq("#{"y" * 28}...")
    end
  end
end

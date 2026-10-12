require "spec_helper"

describe ChefSpec::Coverage::ResourceWrapper do
  let(:resource) do
    double("resource", to_s: "template[/etc/foo]", source_line: "/cookbooks/web/recipes/default.rb:12")
  end
  subject(:wrapper) { described_class.new(resource) }

  describe "#to_s" do
    it "delegates to the wrapped resource" do
      expect(wrapper.to_s).to eq("template[/etc/foo]")
    end
  end

  describe "#source_file" do
    it "extracts the cookbook-relative file from the source line" do
      expect(wrapper.source_file).to eq("web/recipes/default.rb")
    end

    it "returns 'Unknown' when the resource has no source line" do
      allow(resource).to receive(:source_line).and_return(nil)
      expect(wrapper.source_file).to eq("Unknown")
    end
  end

  describe "#source_line" do
    it "extracts the line number as an integer" do
      expect(wrapper.source_line).to eq(12)
    end

    it "returns 'Unknown' when the resource has no source line" do
      allow(resource).to receive(:source_line).and_return(nil)
      expect(wrapper.source_line).to eq("Unknown")
    end
  end

  describe "#touch! and #touched?" do
    it "is untouched by default" do
      expect(wrapper.touched?).to be(false)
    end

    it "is touched after #touch!" do
      wrapper.touch!
      expect(wrapper.touched?).to be(true)
    end
  end

  describe "#to_json" do
    it "serializes the resource details" do
      require "json"
      expect(JSON.parse(wrapper.to_json)).to include(
        "resource" => "template[/etc/foo]",
        "source_line" => 12,
        "touched" => false
      )
    end
  end
end

describe ChefSpec::Coverage do
  subject(:coverage) { described_class.instance }

  describe "#coverage_percentage" do
    it "returns 0.0 when there are no resources instead of NaN" do
      result = coverage.send(:coverage_percentage, 0, 0)
      expect(result).to eq(0.0)
      expect(result).not_to be_nan
    end

    it "calculates the touched percentage" do
      expect(coverage.send(:coverage_percentage, 3, 4)).to eq(75.0)
    end

    it "rounds to two decimal places" do
      expect(coverage.send(:coverage_percentage, 1, 3)).to eq(33.33)
    end
  end
end

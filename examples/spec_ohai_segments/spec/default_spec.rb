require "chefspec"

describe "spec_ohai_segments::default" do
  platform "ubuntu"

  describe "writes a log when x86_64" do
    it { is_expected.to write_log("x86_64") }
    it { is_expected.to_not write_log("ppc64le") }
  end
  context "ppc64le" do
    automatic_attributes["kernel"]["machine"] = "ppc64le"

    describe "writes a log when ppc64le" do
      it { is_expected.to_not write_log("x86_64") }
      it { is_expected.to write_log("ppc64le") }
    end
  end
end

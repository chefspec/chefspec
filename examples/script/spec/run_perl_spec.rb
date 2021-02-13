require "chefspec"

describe "script::run_perl" do
  platform "ubuntu"

  describe "runs a perl script with the default action" do
    it { is_expected.to run_perl("default_action") }
    it { is_expected.to_not run_perl("not_default_action") }
  end

  describe "runs a perl script with an explicit action" do
    it { is_expected.to run_perl("explicit_action") }
  end

  describe "runs a perl script with attributes" do
    it { is_expected.to run_perl("with_attributes").with(creates: "creates") }
    it { is_expected.to_not run_perl("with_attributes").with(creates: "bacon") }
  end
end

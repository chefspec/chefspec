require "chefspec"

describe "script::run_script" do
  platform "ubuntu"

  describe "runs a script with the default action" do
    it { is_expected.to run_script("default_action") }
    it { is_expected.to_not run_script("not_default_action") }
  end

  describe "runs a script with an explicit action" do
    it { is_expected.to run_script("explicit_action") }
  end

  describe "runs a script with attributes" do
    it { is_expected.to run_script("with_attributes").with(creates: "creates") }
    it { is_expected.to_not run_script("with_attributes").with(creates: "bacon") }
  end
end

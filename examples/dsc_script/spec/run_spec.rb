require "chefspec"

describe "dsc_script::run" do
  platform "windows"

  describe "runs dsc_script with default action" do
    it { is_expected.to run_dsc_script("default_action") }
  end

  describe "runs dsc_script with explicit action" do
    it { is_expected.to run_dsc_script("explicit_action") }
  end
end

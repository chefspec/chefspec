require "chefspec"

describe "powershell_script::run" do
  platform "windows"

  describe "runs a powershell_script with the default action" do
    it { is_expected.to run_powershell_script("default_action") }
    it { is_expected.to_not run_powershell_script("not_default_action") }
  end

  describe "runs a powershell_script with an explicit action" do
    it { is_expected.to run_powershell_script("explicit_action") }
  end

  describe "runs a powershell_script with attributes" do
    it { is_expected.to run_powershell_script("with_attributes").with(flags: anything) }
    it { is_expected.to_not run_powershell_script("with_attributes").with(flags: "--not-flags") }
  end
end

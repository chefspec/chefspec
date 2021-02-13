require "chefspec"

describe "macports_package::upgrade" do
  platform "mac_os_x"

  describe "upgrades a macports_package with an explicit action" do
    it { is_expected.to upgrade_macports_package("explicit_action") }
    it { is_expected.to_not upgrade_macports_package("not_explicit_action") }
  end

  describe "upgrades a macports_package with attributes" do
    it { is_expected.to upgrade_macports_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not upgrade_macports_package("with_attributes").with(version: "1.2.3") }
  end

  describe "upgrades a macports_package when specifying the identity attribute" do
    it { is_expected.to upgrade_macports_package("identity_attribute") }
  end
end

require "chefspec"

describe "zypper_package::upgrade" do
  platform "opensuse"

  describe "upgrades a zypper_package with an explicit action" do
    it { is_expected.to upgrade_zypper_package("explicit_action") }
    it { is_expected.to_not upgrade_zypper_package("not_explicit_action") }
  end

  describe "upgrades a zypper_package with attributes" do
    it { is_expected.to upgrade_zypper_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not upgrade_zypper_package("with_attributes").with(version: "1.2.3") }
  end

  describe "upgrades a zypper_package when specifying the identity attribute" do
    it { is_expected.to upgrade_zypper_package("identity_attribute") }
  end
end

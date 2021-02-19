require "chefspec"

describe "ips_package::upgrade" do
  platform "solaris2"

  describe "upgrades a ips_package with an explicit action" do
    it { is_expected.to upgrade_ips_package("explicit_action") }
    it { is_expected.to_not upgrade_ips_package("not_explicit_action") }
  end

  describe "upgrades a ips_package with attributes" do
    it { is_expected.to upgrade_ips_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not upgrade_ips_package("with_attributes").with(version: "1.2.3") }
  end

  describe "upgrades a ips_package when specifying the identity attribute" do
    it { is_expected.to upgrade_ips_package("identity_attribute") }
  end
end

require "chefspec"

describe "package::upgrade" do
  platform "ubuntu"

  describe "upgrades a package with an explicit action" do
    it { is_expected.to upgrade_package("explicit_action") }
    it { is_expected.to_not upgrade_package("not_explicit_action") }
  end

  describe "upgrades a package with attributes" do
    it { is_expected.to upgrade_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not upgrade_package("with_attributes").with(version: "1.2.3") }
  end

  describe "upgrades a package when specifying the identity attribute" do
    it { is_expected.to upgrade_package("identity_attribute") }
  end

  describe "upgrades all packages when given an array of names" do
    it { is_expected.to upgrade_package(%w{with array}) }
  end
end

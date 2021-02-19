require "chefspec"

describe "gem_package::upgrade" do
  platform "ubuntu"

  describe "upgrades a gem_package with an explicit action" do
    it { is_expected.to upgrade_gem_package("explicit_action") }
    it { is_expected.to_not upgrade_gem_package("not_explicit_action") }
  end

  describe "upgrades a gem_package with attributes" do
    it { is_expected.to upgrade_gem_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not upgrade_gem_package("with_attributes").with(version: "1.2.3") }
  end

  describe "upgrades a gem_package when specifying the identity attribute" do
    it { is_expected.to upgrade_gem_package("identity_attribute") }
  end
end

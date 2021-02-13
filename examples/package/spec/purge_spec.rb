require "chefspec"

describe "package::purge" do
  platform "ubuntu"

  describe "purges a package with an explicit action" do
    it { is_expected.to purge_package("explicit_action") }
    it { is_expected.to_not purge_package("not_explicit_action") }
  end

  describe "purges a package with attributes" do
    it { is_expected.to purge_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not purge_package("with_attributes").with(version: "1.2.3") }
  end

  describe "purges a package when specifying the identity attribute" do
    it { is_expected.to purge_package("identity_attribute") }
  end

  describe "purges all packages when given an array of names" do
    it { is_expected.to purge_package(%w{with array}) }
  end
end

require "chefspec"

describe "solaris_package::remove" do
  platform "solaris2"

  describe "removes a solaris_package with an explicit action" do
    it { is_expected.to remove_solaris_package("explicit_action") }
    it { is_expected.to_not remove_solaris_package("not_explicit_action") }
  end

  describe "removes a solaris_package with attributes" do
    it { is_expected.to remove_solaris_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not remove_solaris_package("with_attributes").with(version: "1.2.3") }
  end

  describe "removes a solaris_package when specifying the identity attribute" do
    it { is_expected.to remove_solaris_package("identity_attribute") }
  end
end

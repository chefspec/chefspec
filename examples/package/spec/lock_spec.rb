require "chefspec"

describe "package::lock" do
  platform "ubuntu"

  describe "locks a package with an explicit action" do
    it { is_expected.to lock_package("explicit_action") }
    it { is_expected.to_not lock_package("not_explicit_action") }
  end

  describe "locks a package with attributes" do
    it { is_expected.to lock_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not lock_package("with_attributes").with(version: "1.2.3") }
  end

  describe "locks a package when specifying the identity attribute" do
    it { is_expected.to lock_package("identity_attribute") }
  end

  describe "locks all packages when given an array of names" do
    it { is_expected.to lock_package(%w{with array}) }
  end
end

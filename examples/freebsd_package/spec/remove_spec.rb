require "chefspec"

describe "freebsd_package::remove" do
  platform "freebsd"

  describe "removes a freebsd_package with an explicit action" do
    it { is_expected.to remove_freebsd_package("explicit_action") }
    it { is_expected.to_not remove_freebsd_package("not_explicit_action") }
  end

  describe "removes a freebsd_package with attributes" do
    it { is_expected.to remove_freebsd_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not remove_freebsd_package("with_attributes").with(version: "1.2.3") }
  end

  describe "removes a freebsd_package when specifying the identity attribute" do
    it { is_expected.to remove_freebsd_package("identity_attribute") }
  end
end

require "chefspec"

describe "apt_package::remove" do
  platform "ubuntu"

  describe "removes an apt_package with an explicit action" do
    it { is_expected.to remove_apt_package("explicit_action") }
    it { is_expected.to_not remove_apt_package("not_explicit_action") }
  end

  describe "removes an apt_package with attributes" do
    it { is_expected.to remove_apt_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not remove_apt_package("with_attributes").with(version: "1.2.3") }
  end

  describe "removes an apt_package when specifying the identity attribute" do
    it { is_expected.to remove_apt_package("identity_attribute") }
  end
end

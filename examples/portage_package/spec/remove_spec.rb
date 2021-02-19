require "chefspec"

describe "portage_package::remove" do
  platform "gentoo"

  describe "removes a portage_package with an explicit action" do
    it { is_expected.to remove_portage_package("explicit_action") }
    it { is_expected.to_not remove_portage_package("not_explicit_action") }
  end

  describe "removes a portage_package with attributes" do
    it { is_expected.to remove_portage_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not remove_portage_package("with_attributes").with(version: "1.2.3") }
  end

  describe "removes a portage_package when specifying the identity attribute" do
    it { is_expected.to remove_portage_package("identity_attribute") }
  end
end

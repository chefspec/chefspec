require "chefspec"

describe "paludis_package::purge" do
  platform "gentoo"

  describe "purges a paludis_package with an explicit action" do
    it { is_expected.to purge_paludis_package("explicit_action") }
    it { is_expected.to_not purge_paludis_package("not_explicit_action") }
  end

  describe "purges a paludis_package with attributes" do
    it { is_expected.to purge_paludis_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not purge_paludis_package("with_attributes").with(version: "1.2.3") }
  end

  describe "purges a paludis_package when specifying the identity attribute" do
    it { is_expected.to purge_paludis_package("identity_attribute") }
  end
end

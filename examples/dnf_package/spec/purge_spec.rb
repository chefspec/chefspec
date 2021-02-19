require "chefspec"

if defined?(Chef::Resource::DnfPackage)
  describe "dnf_package::purge" do
    platform "fedora"

    describe "purges a dnf_package with an explicit action" do
      it { is_expected.to purge_dnf_package("explicit_action") }
      it { is_expected.to_not purge_dnf_package("not_explicit_action") }
    end

    describe "purges a dnf_package with attributes" do
      it { is_expected.to purge_dnf_package("with_attributes").with(version: "1.0.0") }
      it { is_expected.to_not purge_dnf_package("with_attributes").with(version: "1.2.3") }
    end

    describe "purges a dnf_package when specifying the identity attribute" do
      it { is_expected.to purge_dnf_package("identity_attribute") }
    end
  end
end

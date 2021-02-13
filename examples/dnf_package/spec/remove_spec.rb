require "chefspec"

if defined?(Chef::Resource::DnfPackage)
  describe "dnf_package::remove" do
    platform "fedora"

    describe "removes a dnf_package with an explicit action" do
      it { is_expected.to remove_dnf_package("explicit_action") }
      it { is_expected.to_not remove_dnf_package("not_explicit_action") }
    end

    describe "removes a dnf_package with attributes" do
      it { is_expected.to remove_dnf_package("with_attributes").with(version: "1.0.0") }
      it { is_expected.to_not remove_dnf_package("with_attributes").with(version: "1.2.3") }
    end

    describe "removes a dnf_package when specifying the identity attribute" do
      it { is_expected.to remove_dnf_package("identity_attribute") }
    end
  end
end

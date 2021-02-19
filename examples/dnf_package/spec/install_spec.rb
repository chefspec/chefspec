require "chefspec"

if defined?(Chef::Resource::DnfPackage)
  describe "dnf_package::install" do
    platform "fedora"

    describe "installs a dnf_package with the default action" do
      it { is_expected.to install_dnf_package("default_action") }
      it { is_expected.to_not install_dnf_package("not_default_action") }
    end

    describe "installs a dnf_package with an explicit action" do
      it { is_expected.to install_dnf_package("explicit_action") }
    end

    describe "installs a dnf_package with attributes" do
      it { is_expected.to install_dnf_package("with_attributes").with(version: "1.0.0") }
      it { is_expected.to_not install_dnf_package("with_attributes").with(version: "1.2.3") }
    end

    describe "installs a dnf_package when specifying the identity attribute" do
      it { is_expected.to install_dnf_package("identity_attribute") }
    end
  end
end

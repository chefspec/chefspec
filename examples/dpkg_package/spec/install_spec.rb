require "chefspec"

describe "dpkg_package::install" do
  platform "ubuntu"

  describe "installs a dpkg_package with the default action" do
    it { is_expected.to install_dpkg_package("default_action") }
    it { is_expected.to_not install_dpkg_package("not_default_action") }
  end

  describe "installs a dpkg_package with an explicit action" do
    it { is_expected.to install_dpkg_package("explicit_action") }
  end

  describe "installs a dpkg_package with attributes" do
    it { is_expected.to install_dpkg_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not install_dpkg_package("with_attributes").with(version: "1.2.3") }
  end

  describe "installs a dpkg_package when specifying the identity attribute" do
    it { is_expected.to install_dpkg_package("identity_attribute") }
  end
end

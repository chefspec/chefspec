require "chefspec"

describe "macports_package::install" do
  platform "mac_os_x"

  describe "installs a macports_package with the default action" do
    it { is_expected.to install_macports_package("default_action") }
    it { is_expected.to_not install_macports_package("not_default_action") }
  end

  describe "installs a macports_package with an explicit action" do
    it { is_expected.to install_macports_package("explicit_action") }
  end

  describe "installs a macports_package with attributes" do
    it { is_expected.to install_macports_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not install_macports_package("with_attributes").with(version: "1.2.3") }
  end

  describe "installs a macports_package when specifying the identity attribute" do
    it { is_expected.to install_macports_package("identity_attribute") }
  end
end

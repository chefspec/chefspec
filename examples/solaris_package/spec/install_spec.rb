require "chefspec"

describe "solaris_package::install" do
  platform "solaris2"

  describe "installs a solaris_package with the default action" do
    it { is_expected.to install_solaris_package("default_action") }
    it { is_expected.to_not install_solaris_package("not_default_action") }
  end

  describe "installs a solaris_package with an explicit action" do
    it { is_expected.to install_solaris_package("explicit_action") }
  end

  describe "installs a solaris_package with attributes" do
    it { is_expected.to install_solaris_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not install_solaris_package("with_attributes").with(version: "1.2.3") }
  end

  describe "installs a solaris_package when specifying the identity attribute" do
    it { is_expected.to install_solaris_package("identity_attribute") }
  end
end

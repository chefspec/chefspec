require "chefspec"

describe "package::install" do
  platform "ubuntu"

  describe "installs a package with the default action" do
    it { is_expected.to install_package("default_action") }
    it { is_expected.to_not install_package("not_default_action") }
  end

  describe "installs a package with an explicit action" do
    it { is_expected.to install_package("explicit_action") }
  end

  describe "installs a package with attributes" do
    it { is_expected.to install_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not install_package("with_attributes").with(version: "1.2.3") }
  end

  describe "installs a package when specifying the identity attribute" do
    it { is_expected.to install_package("identity_attribute") }
  end

  describe "installs all packages when given an array of names" do
    it { is_expected.to install_package(%w{with array}) }
  end
end

require "chefspec"

describe "windows_package::install" do
  platform "windows"

  describe "installs a windows_package with an explicit action" do
    it { is_expected.to install_windows_package("explicit_action") }
    it { is_expected.to_not install_windows_package("not_explicit_action") }
  end

  describe "installs a windows_package with attributes" do
    it { is_expected.to install_windows_package("with_attributes").with(installer_type: :msi) }
    it { is_expected.to_not install_windows_package("with_attributes").with(installer_type: "bacon") }
  end

  describe "installs a windows_package when specifying the identity attribute" do
    it { is_expected.to install_windows_package("identity_attribute") }
  end
end

require "chefspec"

describe "windows_package::remove" do
  platform "windows"

  describe "removes a windows_package with an explicit action" do
    it { is_expected.to remove_windows_package("explicit_action") }
    it { is_expected.to_not remove_windows_package("not_explicit_action") }
  end

  describe "removes a windows_package with attributes" do
    it { is_expected.to remove_windows_package("with_attributes").with(installer_type: :msi) }
    it { is_expected.to_not remove_windows_package("with_attributes").with(installer_type: "bacon") }
  end

  describe "removes a windows_package when specifying the identity attribute" do
    it { is_expected.to remove_windows_package("identity_attribute") }
  end
end

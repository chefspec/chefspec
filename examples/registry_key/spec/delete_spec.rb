require "chefspec"

describe "registry_key::delete" do
  platform "windows"

  describe "deletes a registry_key with an explicit action" do
    it { is_expected.to delete_registry_key('HKEY_LOCAL_MACHINE\explicit_action') }
    it { is_expected.to_not delete_registry_key('HKEY_LOCAL_MACHINE\not_explicit_action') }
  end

  describe "deletes a registry_key with attributes" do
    it { is_expected.to delete_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true) }
    it { is_expected.to_not delete_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: false) }
  end

  describe "deletes a registry_key when specifying the identity attribute" do
    it { is_expected.to delete_registry_key('HKEY_LOCAL_MACHINE\identity_attribute') }
  end
end

require "chefspec"

describe "registry_key::create" do
  platform "windows"

  describe "creates a registry_key with the default action" do
    it { is_expected.to create_registry_key('HKEY_LOCAL_MACHINE\default_action') }
    it { is_expected.to_not create_registry_key('HKEY_LOCAL_MACHINE\not_default_action') }
  end

  describe "creates a registry_key with an explicit action" do
    it { is_expected.to create_registry_key('HKEY_LOCAL_MACHINE\explicit_action') }
  end

  describe "creates a registry_key with attributes" do
    it { is_expected.to create_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true) }
    it { is_expected.to_not create_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: false) }
  end

  describe "creates a registry_key when specifying the identity attribute" do
    it { is_expected.to create_registry_key('HKEY_LOCAL_MACHINE\identity_attribute') }
  end
end

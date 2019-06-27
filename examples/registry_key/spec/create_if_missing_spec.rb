require 'chefspec'

describe 'registry_key::create_if_missing' do
  platform 'windows'

  describe 'creates a registry_key with an explicit action' do
    it { is_expected.to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\explicit_action') }
    it { is_expected.to_not create_registry_key_if_missing('HKEY_LOCAL_MACHINE\not_explicit_action') }
  end

  describe 'creates a registry_key with attributes' do
    it { is_expected.to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true) }
    it { is_expected.to_not create_registry_key_if_missing('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: false) }
  end

  describe 'creates a registry_key when specifying the identity attribute' do
    it { is_expected.to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\identity_attribute') }
  end
end

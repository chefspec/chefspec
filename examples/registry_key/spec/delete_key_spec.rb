require 'chefspec'

describe 'registry_key::delete_key' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'delete_keyes a registry_key with an explicit action' do
    expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\explicit_action')
    expect(chef_run).to_not delete_key_registry_key('HKEY_LOCAL_MACHINE\not_explicit_action')
  end

  it 'delete_keyes a registry_key with attributes' do
    expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true)
    expect(chef_run).to_not delete_key_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: false)
  end

  it 'delete_keyes a registry_key when specifying the identity attribute' do
    expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\identity_attribute')
  end
end

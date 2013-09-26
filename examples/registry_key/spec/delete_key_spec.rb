require 'chefspec'

describe 'registry_key::delete_key' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'delete_keyes a registry_key with an explicit action' do
    expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\explicit_action')
  end

  it 'delete_keyes a registry_key with attributes' do
    expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true)
  end

  it 'delete_keyes a registry_key when specifying the identity attribute' do
    expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\identity_attribute')
  end
end

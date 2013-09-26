require 'chefspec'

describe 'registry_key::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a registry_key with an explicit action' do
    expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\explicit_action')
  end

  it 'deletes a registry_key with attributes' do
    expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true)
  end

  it 'deletes a registry_key when specifying the identity attribute' do
    expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\identity_attribute')
  end
end

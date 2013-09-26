require 'chefspec'

describe 'registry_key::create_if_missing' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a registry_key with an explicit action' do
    expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\explicit_action')
  end

  it 'creates a registry_key with attributes' do
    expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true)
  end

  it 'creates a registry_key when specifying the identity attribute' do
    expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\identity_attribute')
  end
end

require 'chefspec'

describe 'registry_key::create' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a registry_key with the default action' do
    expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\default_action')
  end

  it 'creates a registry_key with an explicit action' do
    expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\explicit_action')
  end

  it 'creates a registry_key with attributes' do
    expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true)
  end

  it 'creates a registry_key when specifying the identity attribute' do
    expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\identity_attribute')
  end
end

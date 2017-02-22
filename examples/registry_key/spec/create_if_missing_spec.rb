require 'chefspec'

describe 'registry_key::create_if_missing' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'creates a registry_key with an explicit action' do
    expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\explicit_action')
    expect(chef_run).to_not create_registry_key_if_missing('HKEY_LOCAL_MACHINE\not_explicit_action')
  end

  it 'creates a registry_key with attributes' do
    expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: true)
    expect(chef_run).to_not create_registry_key_if_missing('HKEY_LOCAL_MACHINE\with_attributes').with(recursive: false)
  end

  it 'creates a registry_key when specifying the identity attribute' do
    expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\identity_attribute')
  end
end

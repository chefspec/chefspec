require 'chefspec'

describe 'mdadm::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a mdadm with the default action' do
    expect(chef_run).to create_mdadm('default_action')
    expect(chef_run).to_not create_mdadm('not_default_action')
  end

  it 'creates a mdadm with an explicit action' do
    expect(chef_run).to create_mdadm('explicit_action')
  end

  it 'creates a mdadm with attributes' do
    expect(chef_run).to create_mdadm('with_attributes').with(chunk: 8)
    expect(chef_run).to_not create_mdadm('with_attributes').with(chunk: 3)
  end

  it 'creates a mdadm when specifying the identity attribute' do
    expect(chef_run).to create_mdadm('identity_attribute')
  end
end

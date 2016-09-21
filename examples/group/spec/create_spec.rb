require 'chefspec'

describe 'group::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a group with the default action' do
    expect(chef_run).to create_group('default_action')
    expect(chef_run).to_not create_group('not_default_action')
  end

  it 'creates a group with an explicit action' do
    expect(chef_run).to create_group('explicit_action')
  end

  it 'creates a group with attributes' do
    expect(chef_run).to create_group('with_attributes').with(gid: 1234)
    expect(chef_run).to_not create_group('with_attributes').with(gid: 5678)
  end

  it 'creates a group when specifying the identity attribute' do
    expect(chef_run).to create_group('identity_attribute')
  end
end

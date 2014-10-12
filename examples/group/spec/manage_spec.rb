require 'chefspec'

describe 'group::manage' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'manages a group with an explicit action' do
    expect(chef_run).to manage_group('explicit_action')
    expect(chef_run).to_not manage_group('not_explicit_action')
  end

  it 'manages a group with attributes' do
    expect(chef_run).to manage_group('with_attributes').with(gid: 1234)
    expect(chef_run).to_not manage_group('with_attributes').with(gid: 5678)
  end

  it 'manages a group when specifying the identity attribute' do
    expect(chef_run).to manage_group('identity_attribute')
  end
end

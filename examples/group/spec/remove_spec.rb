require 'chefspec'

describe 'group::remove' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'removes a group with an explicit action' do
    expect(chef_run).to remove_group('explicit_action')
    expect(chef_run).to_not remove_group('not_explicit_action')
  end

  it 'removes a group with attributes' do
    expect(chef_run).to_not remove_group('with_attributes').with(gid: 5678)
  end

  it 'removes a group when specifying the identity attribute' do
    expect(chef_run).to remove_group('identity_attribute')
  end
end

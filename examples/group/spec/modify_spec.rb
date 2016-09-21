require 'chefspec'

describe 'group::modify' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'modifies a group with an explicit action' do
    expect(chef_run).to modify_group('explicit_action')
    expect(chef_run).to_not modify_group('not_explicit_action')
  end

  it 'modifies a group with attributes' do
    expect(chef_run).to modify_group('with_attributes').with(gid: 1234)
    expect(chef_run).to_not modify_group('with_attributes').with(gid: 5678)
  end

  it 'modifies a group when specifying the identity attribute' do
    expect(chef_run).to modify_group('identity_attribute')
  end
end

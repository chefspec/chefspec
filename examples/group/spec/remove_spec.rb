require 'chefspec'

describe 'group::remove' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'removes a group with an explicit action' do
    expect(chef_run).to remove_group('explicit_action')
  end

  it 'removes a group with attributes' do
    expect(chef_run).to remove_group('with_attributes').with(gid: 1234)
  end

  it 'removes a group when specifying the identity attribute' do
    expect(chef_run).to remove_group('identity_attribute')
  end
end

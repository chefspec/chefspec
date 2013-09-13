require 'chefspec'

describe 'group::manage' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'manages a group with an explicit action' do
    expect(chef_run).to manage_group('explicit_action')
  end

  it 'manages a group with attributes' do
    expect(chef_run).to manage_group('with_attributes').with(gid: 1234)
  end

  it 'manages a group when specifying the identity attribute' do
    expect(chef_run).to manage_group('identity_attribute')
  end
end

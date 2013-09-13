require 'chefspec'

describe 'subversion::sync' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'syncs a subversion with the default action' do
    expect(chef_run).to sync_subversion('/tmp/default_action')
  end

  it 'syncs a subversion with an explicit action' do
    expect(chef_run).to sync_subversion('/tmp/explicit_action')
  end

  it 'syncs a subversion with attributes' do
    expect(chef_run).to sync_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
  end

  it 'syncs a subversion when specifying the identity attribute' do
    expect(chef_run).to sync_subversion('/tmp/identity_attribute')
  end
end

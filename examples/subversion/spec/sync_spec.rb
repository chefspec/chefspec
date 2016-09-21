require 'chefspec'

describe 'subversion::sync' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'syncs a subversion with the default action' do
    expect(chef_run).to sync_subversion('/tmp/default_action')
    expect(chef_run).to_not sync_subversion('/tmp/not_default_action')
  end

  it 'syncs a subversion with an explicit action' do
    expect(chef_run).to sync_subversion('/tmp/explicit_action')
  end

  it 'syncs a subversion with attributes' do
    expect(chef_run).to sync_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
    expect(chef_run).to_not sync_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path')
  end

  it 'syncs a subversion when specifying the identity attribute' do
    expect(chef_run).to sync_subversion('/tmp/identity_attribute')
  end
end

require 'chefspec'

describe 'git::sync' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'syncs a git with the default action' do
    expect(chef_run).to sync_git('/tmp/default_action')
  end

  it 'syncs a git with an explicit action' do
    expect(chef_run).to sync_git('/tmp/explicit_action')
  end

  it 'syncs a git with attributes' do
    expect(chef_run).to sync_git('/tmp/with_attributes').with(repository: 'ssh://git.path')
  end

  it 'syncs a git when specifying the identity attribute' do
    expect(chef_run).to sync_git('/tmp/identity_attribute')
  end
end

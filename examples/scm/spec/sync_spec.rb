require 'chefspec'

describe 'scm::sync' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'syncs a scm with the default action' do
    expect(chef_run).to sync_scm('/tmp/default_action')
  end

  it 'syncs a scm with an explicit action' do
    expect(chef_run).to sync_scm('/tmp/explicit_action')
  end

  it 'syncs a scm with attributes' do
    expect(chef_run).to sync_scm('/tmp/with_attributes').with(repository: 'ssh://scm.path')
  end

  it 'syncs a scm when specifying the identity attribute' do
    expect(chef_run).to sync_scm('/tmp/identity_attribute')
  end
end

require 'chefspec'

describe 'subversion::force_export' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'force_exports a subversion with an explicit action' do
    expect(chef_run).to force_export_subversion('/tmp/explicit_action')
  end

  it 'force_exports a subversion with attributes' do
    expect(chef_run).to force_export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
  end

  it 'force_exports a subversion when specifying the identity attribute' do
    expect(chef_run).to force_export_subversion('/tmp/identity_attribute')
  end
end

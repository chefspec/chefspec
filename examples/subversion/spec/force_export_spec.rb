require 'chefspec'

describe 'subversion::force_export' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'force_exports a subversion with an explicit action' do
    expect(chef_run).to force_export_subversion('/tmp/explicit_action')
    expect(chef_run).to_not force_export_subversion('/tmp/not_explicit_action')
  end

  it 'force_exports a subversion with attributes' do
    expect(chef_run).to force_export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
    expect(chef_run).to_not force_export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path')
  end

  it 'force_exports a subversion when specifying the identity attribute' do
    expect(chef_run).to force_export_subversion('/tmp/identity_attribute')
  end
end

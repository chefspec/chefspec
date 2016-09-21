require 'chefspec'

describe 'subversion::export' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'exports a subversion with an explicit action' do
    expect(chef_run).to export_subversion('/tmp/explicit_action')
    expect(chef_run).to_not export_subversion('/tmp/not_explicit_action')
  end

  it 'exports a subversion with attributes' do
    expect(chef_run).to export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
    expect(chef_run).to_not export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path')
  end

  it 'exports a subversion when specifying the identity attribute' do
    expect(chef_run).to export_subversion('/tmp/identity_attribute')
  end
end

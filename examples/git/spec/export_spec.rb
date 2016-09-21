require 'chefspec'

describe 'git::export' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'exports a git with an explicit action' do
    expect(chef_run).to export_git('/tmp/explicit_action')
    expect(chef_run).to_not export_git('/tmp/not_explicit_action')
  end

  it 'exports a git with attributes' do
    expect(chef_run).to export_git('/tmp/with_attributes').with(repository: 'ssh://git.path')
    expect(chef_run).to_not export_git('/tmp/with_attributes').with(repository: 'ssh://git.other_path')
  end

  it 'exports a git when specifying the identity attribute' do
    expect(chef_run).to export_git('/tmp/identity_attribute')
  end
end

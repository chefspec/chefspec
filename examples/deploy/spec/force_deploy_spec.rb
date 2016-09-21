require 'chefspec'

describe 'deploy::force_deploy' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'force deploys a deploy with an explicit action' do
    expect(chef_run).to force_deploy_deploy('/tmp/explicit_action')
    expect(chef_run).to_not force_deploy_deploy('/tmp/not_explicit_action')
  end

  it 'force deploys a deploy with attributes' do
    expect(chef_run).to force_deploy_deploy('/tmp/with_attributes').with(repo: 'ssh://git.path', migrate: true)
    expect(chef_run).to_not force_deploy_deploy('/tmp/with_attributes').with(repo: 'ssh://git.other_path', migrate: false)
  end
end

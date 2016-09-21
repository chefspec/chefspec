require 'chefspec'

describe 'deploy::rollback' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'rollsback deploys a deploy with an explicit action' do
    expect(chef_run).to rollback_deploy('/tmp/explicit_action')
    expect(chef_run).to_not rollback_deploy('/tmp/not_explicit_action')
  end

  it 'rollsback deploys a deploy with attributes' do
    expect(chef_run).to rollback_deploy('/tmp/with_attributes').with(repo: 'ssh://git.path', migrate: true)
    expect(chef_run).to_not rollback_deploy('/tmp/with_attributes').with(repo: 'ssh://git.other_path', migrate: false)
  end
end

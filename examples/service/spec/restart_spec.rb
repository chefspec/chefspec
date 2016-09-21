require 'chefspec'

describe 'service::restart' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'restarts a service with an explicit action' do
    expect(chef_run).to restart_service('explicit_action')
    expect(chef_run).to_not restart_service('not_explicit_action')
  end

  it 'restarts a service with attributes' do
    expect(chef_run).to restart_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not restart_service('with_attributes').with(pattern: 'bacon')
  end

  it 'restarts a service when specifying the identity attribute' do
    expect(chef_run).to restart_service('identity_attribute')
  end
end

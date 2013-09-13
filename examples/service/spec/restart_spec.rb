require 'chefspec'

describe 'service::restart' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'restarts a service with an explicit action' do
    expect(chef_run).to restart_service('explicit_action')
  end

  it 'restarts a service with attributes' do
    expect(chef_run).to restart_service('with_attributes').with(pattern: 'pattern')
  end

  it 'restarts a service when specifying the identity attribute' do
    expect(chef_run).to restart_service('identity_attribute')
  end
end

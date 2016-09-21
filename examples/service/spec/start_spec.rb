require 'chefspec'

describe 'service::start' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'starts a service with an explicit action' do
    expect(chef_run).to start_service('explicit_action')
    expect(chef_run).to_not start_service('not_explicit_action')
  end

  it 'starts a service with attributes' do
    expect(chef_run).to start_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not start_service('with_attributes').with(pattern: 'bacon')
  end

  it 'starts a service when specifying the identity attribute' do
    expect(chef_run).to start_service('identity_attribute')
  end
end

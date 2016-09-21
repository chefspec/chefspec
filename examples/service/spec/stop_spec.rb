require 'chefspec'

describe 'service::stop' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'stops a service with an explicit action' do
    expect(chef_run).to stop_service('explicit_action')
    expect(chef_run).to_not stop_service('not_explicit_action')
  end

  it 'stops a service with attributes' do
    expect(chef_run).to stop_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not stop_service('with_attributes').with(pattern: 'bacon')
  end

  it 'stops a service when specifying the identity attribute' do
    expect(chef_run).to stop_service('identity_attribute')
  end
end

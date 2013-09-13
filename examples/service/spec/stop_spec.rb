require 'chefspec'

describe 'service::stop' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'stops a service with an explicit action' do
    expect(chef_run).to stop_service('explicit_action')
  end

  it 'stops a service with attributes' do
    expect(chef_run).to stop_service('with_attributes').with(pattern: 'pattern')
  end

  it 'stops a service when specifying the identity attribute' do
    expect(chef_run).to stop_service('identity_attribute')
  end
end

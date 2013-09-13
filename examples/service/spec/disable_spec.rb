require 'chefspec'

describe 'service::disable' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'disables a service with an explicit action' do
    expect(chef_run).to disable_service('explicit_action')
  end

  it 'disables a service with attributes' do
    expect(chef_run).to disable_service('with_attributes').with(pattern: 'pattern')
  end

  it 'disables a service when specifying the identity attribute' do
    expect(chef_run).to disable_service('identity_attribute')
  end
end

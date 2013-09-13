require 'chefspec'

describe 'service::reload' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'reloads a service with an explicit action' do
    expect(chef_run).to reload_service('explicit_action')
  end

  it 'reloads a service with attributes' do
    expect(chef_run).to reload_service('with_attributes').with(pattern: 'pattern')
  end

  it 'reloads a service when specifying the identity attribute' do
    expect(chef_run).to reload_service('identity_attribute')
  end
end

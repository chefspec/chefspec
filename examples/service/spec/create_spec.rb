require 'chefspec'

describe 'service::create' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a service with an explicit action' do
    expect(chef_run).to create_service('explicit_action')
    expect(chef_run).to_not create_service('not_explicit_action')
  end

  it 'creates a service with attributes' do
    expect(chef_run).to create_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not create_service('with_attributes').with(pattern: 'bacon')
  end

  it 'creates a service when specifying the identity attribute' do
    expect(chef_run).to create_service('identity_attribute')
  end
end

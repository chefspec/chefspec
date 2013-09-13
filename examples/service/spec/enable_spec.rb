require 'chefspec'

describe 'service::enable' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'enables a service with an explicit action' do
    expect(chef_run).to enable_service('explicit_action')
  end

  it 'enables a service with attributes' do
    expect(chef_run).to enable_service('with_attributes').with(pattern: 'pattern')
  end

  it 'enables a service when specifying the identity attribute' do
    expect(chef_run).to enable_service('identity_attribute')
  end
end

require 'chefspec'

describe 'service::enable' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'enables a service with an explicit action' do
    expect(chef_run).to enable_service('explicit_action')
    expect(chef_run).to_not enable_service('not_explicit_action')
  end

  it 'enables a service with attributes' do
    expect(chef_run).to enable_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not enable_service('with_attributes').with(pattern: 'bacon')
  end

  it 'enables a service when specifying the identity attribute' do
    expect(chef_run).to enable_service('identity_attribute')
  end
end

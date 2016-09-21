require 'chefspec'

describe 'service::reload' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'reloads a service with an explicit action' do
    expect(chef_run).to reload_service('explicit_action')
    expect(chef_run).to_not reload_service('not_explicit_action')
  end

  it 'reloads a service with attributes' do
    expect(chef_run).to reload_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not reload_service('with_attributes').with(pattern: 'bacon')
  end

  it 'reloads a service when specifying the identity attribute' do
    expect(chef_run).to reload_service('identity_attribute')
  end
end

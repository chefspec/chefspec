require 'chefspec'

describe 'service::disable' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'disables a service with an explicit action' do
    expect(chef_run).to disable_service('explicit_action')
    expect(chef_run).to_not disable_service('not_explicit_action')
  end

  it 'disables a service with attributes' do
    expect(chef_run).to disable_service('with_attributes').with(pattern: 'pattern')
    expect(chef_run).to_not disable_service('with_attributes').with(pattern: 'bacon')
  end

  it 'disables a service when specifying the identity attribute' do
    expect(chef_run).to disable_service('identity_attribute')
  end
end

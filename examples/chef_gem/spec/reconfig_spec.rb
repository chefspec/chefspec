require 'chefspec'

describe 'chef_gem::reconfig' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'reconfigs a chef_gem with an explicit action' do
    expect(chef_run).to reconfig_chef_gem('explicit_action')
    expect(chef_run).to_not reconfig_chef_gem('not_explicit_action')
  end

  it 'reconfigs a chef_gem with attributes' do
    expect(chef_run).to reconfig_chef_gem('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not reconfig_chef_gem('with_attributes').with(version: '1.2.3')
  end

  it 'reconfigs a chef_gem when specifying the identity attribute' do
    expect(chef_run).to reconfig_chef_gem('identity_attribute')
  end
end

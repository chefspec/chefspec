require 'chefspec'

describe 'ohai::reload' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'reloads a ohai with the default action' do
    expect(chef_run).to reload_ohai('default_action')
    expect(chef_run).to_not reload_ohai('not_default_action')
  end

  it 'reloads a ohai with an explicit action' do
    expect(chef_run).to reload_ohai('explicit_action')
  end

  it 'reloads a ohai with attributes' do
    expect(chef_run).to reload_ohai('with_attributes').with(plugin: 'plugin')
    expect(chef_run).to_not reload_ohai('with_attributes').with(plugin: 'not_plugin')
  end

  it 'reloads a ohai when specifying the identity attribute' do
    expect(chef_run).to reload_ohai('identity_attribute')
  end
end

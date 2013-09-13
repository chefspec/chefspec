require 'chefspec'

describe 'ohai::reload' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'reloads a ohai with the default action' do
    expect(chef_run).to reload_ohai('default_action')
  end

  it 'reloads a ohai with an explicit action' do
    expect(chef_run).to reload_ohai('explicit_action')
  end

  it 'reloads a ohai with attributes' do
    expect(chef_run).to reload_ohai('with_attributes').with(plugin: 'plugin')
  end

  it 'reloads a ohai when specifying the identity attribute' do
    expect(chef_run).to reload_ohai('identity_attribute')
  end
end

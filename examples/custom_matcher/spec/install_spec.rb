require 'chefspec'

describe 'custom_matcher::install' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'installs a custom_matcher with the default action' do
    expect(chef_run).to install_custom_matcher_thing('default_action')
    expect(chef_run).to_not install_custom_matcher_thing('not_default_action')
  end

  it 'installs a custom_matcher with an explicit action' do
    expect(chef_run).to install_custom_matcher_thing('explicit_action')
  end

  it 'installs a custom_matcher with attributes' do
    expect(chef_run).to install_custom_matcher_thing('with_attributes').with(config: true)
    expect(chef_run).to_not install_custom_matcher_thing('with_attributes').with(config: false)
  end

  it 'installs a custom_matcher when specifying the identity attribute' do
    expect(chef_run).to install_custom_matcher_thing('identity_attribute')
  end

  it 'defines a runner method' do
    expect(chef_run).to respond_to(:custom_matcher_thing)
  end
end

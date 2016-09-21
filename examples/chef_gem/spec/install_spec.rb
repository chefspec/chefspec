require 'chefspec'

describe 'chef_gem::install' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'installs a chef_gem with the default action' do
    expect(chef_run).to install_chef_gem('default_action')
    expect(chef_run).to_not install_chef_gem('not_default_action')
  end

  it 'installs a chef_gem with an explicit action' do
    expect(chef_run).to install_chef_gem('explicit_action')
  end

  it 'installs a chef_gem with attributes' do
    expect(chef_run).to install_chef_gem('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_chef_gem('with_attributes').with(version: '1.2.3')
  end

  it 'installs a chef_gem when specifying the identity attribute' do
    expect(chef_run).to install_chef_gem('identity_attribute')
  end
end

require 'chefspec'

describe 'homebrew_package::install' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'installs a homebrew_package with the default action' do
    expect(chef_run).to install_homebrew_package('default_action')
    expect(chef_run).to_not install_homebrew_package('not_default_action')
  end

  it 'installs a homebrew_package with an explicit action' do
    expect(chef_run).to install_homebrew_package('explicit_action')
  end

  it 'installs a homebrew_package with attributes' do
    expect(chef_run).to install_homebrew_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_homebrew_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a homebrew_package when specifying the identity attribute' do
    expect(chef_run).to install_homebrew_package('identity_attribute')
  end
end

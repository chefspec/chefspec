require 'chefspec'

describe 'macports_package::install' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'installs a macports_package with the default action' do
    expect(chef_run).to install_macports_package('default_action')
    expect(chef_run).to_not install_macports_package('not_default_action')
  end

  it 'installs a macports_package with an explicit action' do
    expect(chef_run).to install_macports_package('explicit_action')
  end

  it 'installs a macports_package with attributes' do
    expect(chef_run).to install_macports_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_macports_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a macports_package when specifying the identity attribute' do
    expect(chef_run).to install_macports_package('identity_attribute')
  end
end

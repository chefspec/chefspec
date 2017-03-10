require 'chefspec'

describe 'osx_profile::install' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'installs an osx_profile with an explicit action' do
    expect(chef_run).to install_osx_profile('explicit_action')
    expect(chef_run).to_not install_osx_profile('not_explicit_action')
  end

  it 'starts an osx_profile with an implicit_action action' do
    expect(chef_run).to install_osx_profile('implicit_action')
    expect(chef_run).to_not install_osx_profile('other_profile')
  end
end

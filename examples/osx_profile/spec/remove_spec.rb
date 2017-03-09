require 'chefspec'

describe 'osx_profile::remove' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'removes an osx_profile from the resource name' do
    expect(chef_run).to remove_osx_profile('specifying profile')
  end

  it 'removes an osx_profile from the profile property' do
    expect(chef_run).to remove_osx_profile('screensaver/com.company.screensaver.mobileconfig')
  end
end

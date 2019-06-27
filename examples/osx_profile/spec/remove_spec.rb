require 'chefspec'

describe 'osx_profile::remove' do
  platform 'mac_os_x'

  describe 'removes an osx_profile from the resource name' do
    it { is_expected.to remove_osx_profile('specifying profile') }
  end

  describe 'removes an osx_profile from the profile property' do
    it { is_expected.to remove_osx_profile('screensaver/com.company.screensaver.mobileconfig') }
  end
end

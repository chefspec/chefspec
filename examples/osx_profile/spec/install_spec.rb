require 'chefspec'

describe 'osx_profile::install' do
  platform 'mac_os_x'

  describe 'installs an osx_profile with an explicit action' do
    it { is_expected.to install_osx_profile('explicit_action') }
    it { is_expected.to_not install_osx_profile('not_explicit_action') }
  end

  describe 'starts an osx_profile with an implicit_action action' do
    it { is_expected.to install_osx_profile('implicit_action') }
    it { is_expected.to_not install_osx_profile('other_profile') }
  end
end

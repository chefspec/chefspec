require 'chefspec'

describe 'homebrew_package::remove' do
  platform 'mac_os_x'

  describe 'removes a homebrew_package with an explicit action' do
    it { is_expected.to remove_homebrew_package('explicit_action') }
    it { is_expected.to_not remove_homebrew_package('not_explicit_action') }
  end

  describe 'removes a homebrew_package with attributes' do
    it { is_expected.to remove_homebrew_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_homebrew_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a homebrew_package when specifying the identity attribute' do
    it { is_expected.to remove_homebrew_package('identity_attribute') }
  end
end

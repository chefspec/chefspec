require 'chefspec'

describe 'macports_package::remove' do
  platform 'mac_os_x'

  describe 'removes a macports_package with an explicit action' do
    it { is_expected.to remove_macports_package('explicit_action') }
    it { is_expected.to_not remove_macports_package('not_explicit_action') }
  end

  describe 'removes a macports_package with attributes' do
    it { is_expected.to remove_macports_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_macports_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a macports_package when specifying the identity attribute' do
    it { is_expected.to remove_macports_package('identity_attribute') }
  end
end

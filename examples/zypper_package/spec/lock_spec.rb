require 'chefspec'

describe 'zypper_package::lock' do
  platform 'opensuse'

  describe 'locks a zypper_package with an explicit action' do
    it { is_expected.to lock_zypper_package('explicit_action') }
    it { is_expected.to_not lock_zypper_package('not_explicit_action') }
  end

  describe 'locks a zypper_package with attributes' do
    it { is_expected.to lock_zypper_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not lock_zypper_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'locks a zypper_package when specifying the identity attribute' do
    it { is_expected.to lock_zypper_package('identity_attribute') }
  end
end

require 'chefspec'

describe 'rpm_package::remove' do
  platform 'centos'

  describe 'removes a rpm_package with an explicit action' do
    it { is_expected.to remove_rpm_package('explicit_action') }
    it { is_expected.to_not remove_rpm_package('not_explicit_action') }
  end

  describe 'removes a rpm_package with attributes' do
    it { is_expected.to remove_rpm_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_rpm_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a rpm_package when specifying the identity attribute' do
    it { is_expected.to remove_rpm_package('identity_attribute') }
  end
end

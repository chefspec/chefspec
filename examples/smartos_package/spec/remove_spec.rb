require 'chefspec'

describe 'smartos_package::remove' do
  platform 'solaris2'

  describe 'removes a smartos_package with an explicit action' do
    it { is_expected.to remove_smartos_package('explicit_action') }
    it { is_expected.to_not remove_smartos_package('not_explicit_action') }
  end

  describe 'removes a smartos_package with attributes' do
    it { is_expected.to remove_smartos_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_smartos_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a smartos_package when specifying the identity attribute' do
    it { is_expected.to remove_smartos_package('identity_attribute') }
  end
end

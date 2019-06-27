require 'chefspec'

describe 'openbsd_package::remove' do
  platform 'openbsd'

  describe 'removes a openbsd_package with an explicit action' do
    it { is_expected.to remove_openbsd_package('explicit_action') }
    it { is_expected.to_not remove_openbsd_package('not_explicit_action') }
  end

  describe 'removes a openbsd_package with attributes' do
    it { is_expected.to remove_openbsd_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_openbsd_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a openbsd_package when specifying the identity attribute' do
    it { is_expected.to remove_openbsd_package('identity_attribute') }
  end
end

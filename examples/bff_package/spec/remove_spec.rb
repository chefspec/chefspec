require 'chefspec'

describe 'bff_package::remove' do
  platform 'aix'

  describe 'removes a bff_package with an explicit action' do
    it { is_expected.to remove_bff_package('explicit_action') }
    it { is_expected.to_not remove_bff_package('not_explicit_action') }
  end

  describe 'removes a bff_package with attributes' do
    it { is_expected.to remove_bff_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_bff_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a bff_package when specifying the identity attribute' do
    it { is_expected.to remove_bff_package('identity_attribute') }
  end
end

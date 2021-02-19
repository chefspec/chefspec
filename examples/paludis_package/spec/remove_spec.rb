require 'chefspec'

describe 'paludis_package::remove' do
  platform 'gentoo'

  describe 'removes a paludis_package with an explicit action' do
    it { is_expected.to remove_paludis_package('explicit_action') }
    it { is_expected.to_not remove_paludis_package('not_explicit_action') }
  end

  describe 'removes a paludis_package with attributes' do
    it { is_expected.to remove_paludis_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_paludis_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a paludis_package when specifying the identity attribute' do
    it { is_expected.to remove_paludis_package('identity_attribute') }
  end
end

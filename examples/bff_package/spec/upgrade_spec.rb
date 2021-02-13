require 'chefspec'

describe 'bff_package::upgrade' do
  platform 'aix'

  describe 'upgrades a bff_package with an explicit action' do
    it { is_expected.to upgrade_bff_package('explicit_action') }
    it { is_expected.to_not upgrade_bff_package('not_explicit_action') }
  end

  describe 'upgrades a bff_package with attributes' do
    it { is_expected.to upgrade_bff_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not upgrade_bff_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'upgrades a bff_package when specifying the identity attribute' do
    it { is_expected.to upgrade_bff_package('identity_attribute') }
  end
end

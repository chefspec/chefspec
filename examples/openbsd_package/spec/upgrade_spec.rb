require 'chefspec'

describe 'openbsd_package::upgrade' do
  platform 'openbsd'

  describe 'upgrades a openbsd_package with an explicit action' do
    it { is_expected.to upgrade_openbsd_package('explicit_action') }
    it { is_expected.to_not upgrade_openbsd_package('not_explicit_action') }
  end

  describe 'upgrades a openbsd_package with attributes' do
    it { is_expected.to upgrade_openbsd_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not upgrade_openbsd_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'upgrades a openbsd_package when specifying the identity attribute' do
    it { is_expected.to upgrade_openbsd_package('identity_attribute') }
  end
end

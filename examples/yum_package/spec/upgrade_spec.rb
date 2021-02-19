require 'chefspec'

describe 'yum_package::upgrade' do
  platform 'centos'

  describe 'upgrades a yum_package with an explicit action' do
    it { is_expected.to upgrade_yum_package('explicit_action') }
    it { is_expected.to_not upgrade_yum_package('not_explicit_action') }
  end

  describe 'upgrades a yum_package with attributes' do
    it { is_expected.to upgrade_yum_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not upgrade_yum_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'upgrades a yum_package when specifying the identity attribute' do
    it { is_expected.to upgrade_yum_package('identity_attribute') }
  end
end

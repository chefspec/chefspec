require 'chefspec'

describe 'dpkg_package::purge' do
  platform 'ubuntu'

  describe 'purges a dpkg_package with an explicit action' do
    it { is_expected.to purge_dpkg_package('explicit_action') }
    it { is_expected.to_not purge_dpkg_package('not_explicit_action') }
  end

  describe 'purges a dpkg_package with attributes' do
    it { is_expected.to purge_dpkg_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not purge_dpkg_package('with_attributes').with(version: '1.2.3.') }
  end

  describe 'purges a dpkg_package when specifying the identity attribute' do
    it { is_expected.to purge_dpkg_package('identity_attribute') }
  end
end

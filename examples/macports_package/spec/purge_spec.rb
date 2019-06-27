require 'chefspec'

describe 'macports_package::purge' do
  platform 'mac_os_x'

  describe 'purges a macports_package with an explicit action' do
    it { is_expected.to purge_macports_package('explicit_action') }
    it { is_expected.to_not purge_macports_package('not_explicit_action') }
  end

  describe 'purges a macports_package with attributes' do
    it { is_expected.to purge_macports_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not purge_macports_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'purges a macports_package when specifying the identity attribute' do
    it { is_expected.to purge_macports_package('identity_attribute') }
  end
end

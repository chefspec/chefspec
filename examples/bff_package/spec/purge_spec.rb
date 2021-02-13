require 'chefspec'

describe 'bff_package::purge' do
  platform 'aix'

  describe 'purges a bff_package with an explicit action' do
    it { is_expected.to purge_bff_package('explicit_action') }
    it { is_expected.to_not purge_bff_package('not_explicit_action') }
  end

  describe 'purges a bff_package with attributes' do
    it { is_expected.to purge_bff_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not purge_bff_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'purges a bff_package when specifying the identity attribute' do
    it { is_expected.to purge_bff_package('identity_attribute') }
  end
end

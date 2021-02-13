require 'chefspec'

describe 'package::unlock' do
  platform 'ubuntu'

  describe 'unlocks a package with an explicit action' do
    it { is_expected.to unlock_package('explicit_action') }
    it { is_expected.to_not unlock_package('not_explicit_action') }
  end

  describe 'unlocks a package with attributes' do
    it { is_expected.to unlock_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not unlock_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'unlocks a package when specifying the identity attribute' do
    it { is_expected.to unlock_package('identity_attribute') }
  end

  describe 'unlocks all packages when given an array of names' do
    it { is_expected.to unlock_package(%w(with array)) }
  end
end

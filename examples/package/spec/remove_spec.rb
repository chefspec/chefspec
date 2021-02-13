require 'chefspec'

describe 'package::remove' do
  platform 'ubuntu'

  describe 'removes a package with an explicit action' do
    it { is_expected.to remove_package('explicit_action') }
    it { is_expected.to_not remove_package('not_explicit_action') }
  end

  describe 'removes a package with attributes' do
    it { is_expected.to remove_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a package when specifying the identity attribute' do
    it { is_expected.to remove_package('identity_attribute') }
  end

  describe 'removes all packages when given an array of names' do
    it { is_expected.to remove_package(%w(with array)) }
  end
end

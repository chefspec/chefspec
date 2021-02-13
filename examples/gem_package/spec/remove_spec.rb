require 'chefspec'

describe 'gem_package::remove' do
  platform 'ubuntu'

  describe 'removes a gem_package with an explicit action' do
    it { is_expected.to remove_gem_package('explicit_action') }
    it { is_expected.to_not remove_gem_package('not_explicit_action') }
  end

  describe 'removes a gem_package with attributes' do
    it { is_expected.to remove_gem_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_gem_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a gem_package when specifying the identity attribute' do
    it { is_expected.to remove_gem_package('identity_attribute') }
  end
end

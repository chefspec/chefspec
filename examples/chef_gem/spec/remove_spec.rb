require 'chefspec'

describe 'chef_gem::remove' do
  platform 'ubuntu'

  describe 'removes a chef_gem with an explicit action' do
    it { is_expected.to remove_chef_gem('explicit_action') }
    it { is_expected.to_not remove_chef_gem('not_explicit_action') }
  end

  describe 'removes a chef_gem with attributes' do
    it { is_expected.to remove_chef_gem('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not remove_chef_gem('with_attributes').with(version: '1.2.3') }
  end

  describe 'removes a chef_gem when specifying the identity attribute' do
    it { is_expected.to remove_chef_gem('identity_attribute') }
  end
end

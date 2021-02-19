require 'chefspec'

describe 'chef_gem::install' do
  platform 'ubuntu'

  describe 'installs a chef_gem with the default action' do
    it { is_expected.to install_chef_gem('default_action') }
    it { is_expected.to_not install_chef_gem('not_default_action') }
  end

  describe 'installs a chef_gem with an explicit action' do
    it { is_expected.to install_chef_gem('explicit_action') }
  end

  describe 'installs a chef_gem with attributes' do
    it { is_expected.to install_chef_gem('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not install_chef_gem('with_attributes').with(version: '1.2.3') }
  end

  describe 'installs a chef_gem when specifying the identity attribute' do
    it { is_expected.to install_chef_gem('identity_attribute') }
  end
end

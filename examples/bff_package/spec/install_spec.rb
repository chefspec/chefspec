require 'chefspec'

describe 'bff_package::install' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'aix', version: '7.1').converge(described_recipe) }

  describe 'installs a bff_package with the default action' do
    it { is_expected.to install_bff_package('default_action') }
    it { is_expected.to_not install_bff_package('not_default_action') }
  end

  describe 'installs a bff_package with an explicit action' do
    it { is_expected.to install_bff_package('explicit_action') }
  end

  describe 'installs a bff_package with attributes' do
    it { is_expected.to install_bff_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not install_bff_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'installs a bff_package when specifying the identity attribute' do
    it { is_expected.to install_bff_package('identity_attribute') }
  end
end

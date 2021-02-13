require 'chefspec'

describe 'ips_package::install' do
  platform 'solaris2'

  describe 'installs a ips_package with the default action' do
    it { is_expected.to install_ips_package('default_action') }
    it { is_expected.to_not install_ips_package('not_default_action') }
  end

  describe 'installs a ips_package with an explicit action' do
    it { is_expected.to install_ips_package('explicit_action') }
  end

  describe 'installs a ips_package with attributes' do
    it { is_expected.to install_ips_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not install_ips_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'installs a ips_package when specifying the identity attribute' do
    it { is_expected.to install_ips_package('identity_attribute') }
  end
end

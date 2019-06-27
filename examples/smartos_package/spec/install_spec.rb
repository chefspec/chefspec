require 'chefspec'

describe 'smartos_package::install' do
  platform 'solaris2'

  describe 'installs a smartos_package with the default action' do
    it { is_expected.to install_smartos_package('default_action') }
    it { is_expected.to_not install_smartos_package('not_default_action') }
  end

  describe 'installs a smartos_package with an explicit action' do
    it { is_expected.to install_smartos_package('explicit_action') }
  end

  describe 'installs a smartos_package with attributes' do
    it { is_expected.to install_smartos_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not install_smartos_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'installs a smartos_package when specifying the identity attribute' do
    it { is_expected.to install_smartos_package('identity_attribute') }
  end
end

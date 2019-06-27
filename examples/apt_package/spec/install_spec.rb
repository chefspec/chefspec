require 'chefspec'

describe 'apt_package::install' do
  platform 'ubuntu'

  describe 'installs an apt_package with the default action' do
    it { is_expected.to install_apt_package('default_action') }
    it { is_expected.to_not install_apt_package('not_default_action') }
  end

  describe 'installs an apt_package with an explicit action' do
    it { is_expected.to install_apt_package('explicit_action') }
  end

  describe 'installs an apt_package with attributes' do
    it { is_expected.to install_apt_package('with_attributes').with(version: '1.0.0') }
    it { is_expected.to_not install_apt_package('with_attributes').with(version: '1.2.3') }
  end

  describe 'installs an apt_package when specifying the identity attribute' do
    it { is_expected.to install_apt_package('identity_attribute') }
  end
end

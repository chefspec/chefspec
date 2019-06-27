require 'chefspec'

if defined?(Chef::Resource::CabPackage)
  describe 'cab_package::install' do
    platform 'windows'

    describe 'installs a cab_package with the default action' do
      it { is_expected.to install_cab_package('default_action') }
      it { is_expected.to_not install_cab_package('not_default_action') }
    end

    describe 'installs a cab_package with an explicit action' do
      it { is_expected.to install_cab_package('explicit_action') }
    end

    describe 'installs a cab_package with attributes' do
      it { is_expected.to install_cab_package('with_attributes').with(version: '1.2.3') }
      it { is_expected.to_not install_cab_package('with_attributes').with(version: '1.2.4') }
    end

    describe 'installs a cab_package when specifying the identity attribute' do
      it { is_expected.to install_cab_package('identity_attribute') }
    end
  end
end

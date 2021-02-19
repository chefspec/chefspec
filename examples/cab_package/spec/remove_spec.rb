require 'chefspec'

if defined?(Chef::Resource::CabPackage)
  describe 'cab_package::remove' do
    platform 'windows'

    describe 'removes a cab_package with an explicit action' do
      it { is_expected.to remove_cab_package('explicit_action') }
      it { is_expected.to_not remove_cab_package('not_explicit_action') }
    end

    describe 'removes a cab_package with attributes' do
      it { is_expected.to remove_cab_package('with_attributes').with(version: '1.2.3') }
      it { is_expected.to_not remove_cab_package('with_attributes').with(version: '1.2.4') }
    end

    describe 'removes a cab_package when specifying the identity attribute' do
      it { is_expected.to remove_cab_package('identity_attribute') }
    end
  end
end

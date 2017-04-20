require 'chefspec'

if defined?(Chef::Resource::CabPackage)
  describe 'cab_package::install' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
        .converge(described_recipe)
    end

    it 'installs a cab_package with the default action' do
      expect(chef_run).to install_cab_package('default_action')
      expect(chef_run).to_not install_cab_package('not_default_action')
    end

    it 'installs a cab_package with an explicit action' do
      expect(chef_run).to install_cab_package('explicit_action')
    end

    it 'installs a cab_package with attributes' do
      expect(chef_run).to install_cab_package('with_attributes').with(version: '1.2.3')
      expect(chef_run).to_not install_cab_package('with_attributes').with(version: '1.2.4')
    end

    it 'installs a cab_package when specifying the identity attribute' do
      expect(chef_run).to install_cab_package('identity_attribute')
    end
  end
end

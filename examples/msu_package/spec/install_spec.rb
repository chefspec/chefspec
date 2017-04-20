require 'chefspec'

if defined?(Chef::Resource::MsuPackage)
  describe 'msu_package::install' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
        .converge(described_recipe)
    end

    it 'installs a msu_package with the default action' do
      expect(chef_run).to install_msu_package('default_action')
      expect(chef_run).to_not install_msu_package('not_default_action')
    end

    it 'installs a msu_package with an explicit action' do
      expect(chef_run).to install_msu_package('explicit_action')
    end

    it 'installs a msu_package with attributes' do
      expect(chef_run).to install_msu_package('with_attributes').with(version: '1.0.0')
      expect(chef_run).to_not install_msu_package('with_attributes').with(version: '1.2.3')
    end

    it 'installs a msu_package when specifying the identity attribute' do
      expect(chef_run).to install_msu_package('identity_attribute')
    end
  end
end

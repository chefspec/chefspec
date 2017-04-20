require 'chefspec'

if defined?(Chef::Resource::DnfPackage)
  describe 'dnf_package::install' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'fedora', version: '25')
        .converge(described_recipe)
    end

    it 'installs a dnf_package with the default action' do
      expect(chef_run).to install_dnf_package('default_action')
      expect(chef_run).to_not install_dnf_package('not_default_action')
    end

    it 'installs a dnf_package with an explicit action' do
      expect(chef_run).to install_dnf_package('explicit_action')
    end

    it 'installs a dnf_package with attributes' do
      expect(chef_run).to install_dnf_package('with_attributes').with(version: '1.0.0')
      expect(chef_run).to_not install_dnf_package('with_attributes').with(version: '1.2.3')
    end

    it 'installs a dnf_package when specifying the identity attribute' do
      expect(chef_run).to install_dnf_package('identity_attribute')
    end
  end
end

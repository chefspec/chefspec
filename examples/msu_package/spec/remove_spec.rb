require 'chefspec'

if defined?(Chef::Resource::MsuPackage)
  describe 'msu_package::remove' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
        .converge(described_recipe)
    end

    it 'removes a msu_package with an explicit action' do
      expect(chef_run).to remove_msu_package('explicit_action')
      expect(chef_run).to_not remove_msu_package('not_explicit_action')
    end

    it 'removes a msu_package with attributes' do
      expect(chef_run).to remove_msu_package('with_attributes').with(version: '1.0.0')
      expect(chef_run).to_not remove_msu_package('with_attributes').with(version: '1.2.3')
    end

    it 'removes a msu_package when specifying the identity attribute' do
      expect(chef_run).to remove_msu_package('identity_attribute')
    end
  end
end

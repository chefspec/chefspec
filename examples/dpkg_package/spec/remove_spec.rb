require 'chefspec'

describe 'dpkg_package::remove' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'removes a dpkg_package with an explicit action' do
    expect(chef_run).to remove_dpkg_package('explicit_action')
    expect(chef_run).to_not remove_dpkg_package('not_explicit_action')
  end

  it 'removes a dpkg_package with attributes' do
    expect(chef_run).to remove_dpkg_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not remove_dpkg_package('with_attributes').with(version: '1.2.3')
  end

  it 'removes a dpkg_package when specifying the identity attribute' do
    expect(chef_run).to remove_dpkg_package('identity_attribute')
  end
end

require 'chefspec'

describe 'ips_package::upgrade' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'solaris2', version: '5.11')
                          .converge(described_recipe)
  end

  it 'upgrades a ips_package with an explicit action' do
    expect(chef_run).to upgrade_ips_package('explicit_action')
    expect(chef_run).to_not upgrade_ips_package('not_explicit_action')
  end

  it 'upgrades a ips_package with attributes' do
    expect(chef_run).to upgrade_ips_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not upgrade_ips_package('with_attributes').with(version: '1.2.3')
  end

  it 'upgrades a ips_package when specifying the identity attribute' do
    expect(chef_run).to upgrade_ips_package('identity_attribute')
  end
end

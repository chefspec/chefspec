require 'chefspec'

describe 'package::upgrade' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'upgrades a package with an explicit action' do
    expect(chef_run).to upgrade_package('explicit_action')
    expect(chef_run).to_not upgrade_package('not_explicit_action')
  end

  it 'upgrades a package with attributes' do
    expect(chef_run).to upgrade_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not upgrade_package('with_attributes').with(version: '1.2.3')
  end

  it 'upgrades a package when specifying the identity attribute' do
    expect(chef_run).to upgrade_package('identity_attribute')
  end

  it 'upgrades all packages when given an array of names' do
    expect(chef_run).to upgrade_package(%w(with array))
  end
end

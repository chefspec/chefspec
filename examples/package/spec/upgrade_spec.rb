require 'chefspec'

describe 'package::upgrade' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'upgrades a package with an explicit action' do
    expect(chef_run).to upgrade_package('explicit_action')
  end

  it 'upgrades a package with attributes' do
    expect(chef_run).to upgrade_package('with_attributes').with(version: '1.0.0')
  end

  it 'upgrades a package when specifying the identity attribute' do
    expect(chef_run).to upgrade_package('identity_attribute')
  end
end

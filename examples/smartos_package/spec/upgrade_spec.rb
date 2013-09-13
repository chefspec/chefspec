require 'chefspec'

describe 'smartos_package::upgrade' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'upgrades a smartos_package with an explicit action' do
    expect(chef_run).to upgrade_smartos_package('explicit_action')
  end

  it 'upgrades a smartos_package with attributes' do
    expect(chef_run).to upgrade_smartos_package('with_attributes').with(version: '1.0.0')
  end

  it 'upgrades a smartos_package when specifying the identity attribute' do
    expect(chef_run).to upgrade_smartos_package('identity_attribute')
  end
end

require 'chefspec'

RSpec.configure do |config|
  config.platform = 'centos'
  config.version  = '6.5'
end

describe 'rpm_package::upgrade' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'upgrades a rpm_package with an explicit action' do
    expect(chef_run).to upgrade_rpm_package('explicit_action')
    expect(chef_run).to_not upgrade_rpm_package('not_explicit_action')
  end

  it 'upgrades a rpm_package with attributes' do
    expect(chef_run).to upgrade_rpm_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not upgrade_rpm_package('with_attributes').with(version: '1.2.3')
  end

  it 'upgrades a rpm_package when specifying the identity attribute' do
    expect(chef_run).to upgrade_rpm_package('identity_attribute')
  end
end

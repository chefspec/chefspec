require 'chefspec'

describe 'homebrew_package::upgrade' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'upgrades a homebrew_package with an explicit action' do
    expect(chef_run).to upgrade_homebrew_package('explicit_action')
    expect(chef_run).to_not upgrade_homebrew_package('not_explicit_action')
  end

  it 'upgrades a homebrew_package with attributes' do
    expect(chef_run).to upgrade_homebrew_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not upgrade_homebrew_package('with_attributes').with(version: '1.2.3')
  end

  it 'upgrades a homebrew_package when specifying the identity attribute' do
    expect(chef_run).to upgrade_homebrew_package('identity_attribute')
  end
end

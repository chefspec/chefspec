require 'chefspec'

describe 'easy_install_package::upgrade' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'upgrades a easy_install_package with an explicit action' do
    expect(chef_run).to upgrade_easy_install_package('explicit_action')
    expect(chef_run).to_not upgrade_easy_install_package('not_explicit_action')
  end

  it 'upgrades a easy_install_package with attributes' do
    expect(chef_run).to upgrade_easy_install_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not upgrade_easy_install_package('with_attributes').with(version: '1.2.3')
  end

  it 'upgrades a easy_install_package when specifying the identity attribute' do
    expect(chef_run).to upgrade_easy_install_package('identity_attribute')
  end
end

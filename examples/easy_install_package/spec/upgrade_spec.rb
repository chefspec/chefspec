require 'chefspec'

describe 'easy_install_package::upgrade' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'upgrades a easy_install_package with an explicit action' do
    expect(chef_run).to upgrade_easy_install_package('explicit_action')
  end

  it 'upgrades a easy_install_package with attributes' do
    expect(chef_run).to upgrade_easy_install_package('with_attributes').with(version: '1.0.0')
  end

  it 'upgrades a easy_install_package when specifying the identity attribute' do
    expect(chef_run).to upgrade_easy_install_package('identity_attribute')
  end
end

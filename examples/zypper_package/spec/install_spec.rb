require 'chefspec'

describe 'zypper_package::install' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'opensuse', version: '42.1').converge(described_recipe) }

  it 'installs a zypper_package with the default action' do
    expect(chef_run).to install_zypper_package('default_action')
    expect(chef_run).to_not install_zypper_package('not_default_action')
  end

  it 'installs a zypper_package with an explicit action' do
    expect(chef_run).to install_zypper_package('explicit_action')
  end

  it 'installs a zypper_package with attributes' do
    expect(chef_run).to install_zypper_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_zypper_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a zypper_package when specifying the identity attribute' do
    expect(chef_run).to install_zypper_package('identity_attribute')
  end
end

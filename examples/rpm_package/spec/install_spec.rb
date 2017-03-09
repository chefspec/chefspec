require 'chefspec'

describe 'rpm_package::install' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.3.1611')
                          .converge(described_recipe)
  end

  it 'installs a rpm_package with the default action' do
    expect(chef_run).to install_rpm_package('default_action')
    expect(chef_run).to_not install_rpm_package('not_default_action')
  end

  it 'installs a rpm_package with an explicit action' do
    expect(chef_run).to install_rpm_package('explicit_action')
  end

  it 'installs a rpm_package with attributes' do
    expect(chef_run).to install_rpm_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_rpm_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a rpm_package when specifying the identity attribute' do
    expect(chef_run).to install_rpm_package('identity_attribute')
  end
end

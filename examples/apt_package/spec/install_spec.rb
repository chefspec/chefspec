require 'chefspec'

describe 'apt_package::install' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'installs a apt_package with the default action' do
    expect(chef_run).to install_apt_package('default_action')
    expect(chef_run).to_not install_apt_package('not_default_action')
  end

  it 'installs a apt_package with an explicit action' do
    expect(chef_run).to install_apt_package('explicit_action')
  end

  it 'installs a apt_package with attributes' do
    expect(chef_run).to install_apt_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_apt_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a apt_package when specifying the identity attribute' do
    expect(chef_run).to install_apt_package('identity_attribute')
  end
end

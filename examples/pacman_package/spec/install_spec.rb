require 'chefspec'

describe 'pacman_package::install' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'arch', version: '4.10.13-1-ARCH')
                          .converge(described_recipe)
  end

  it 'installs a pacman_package with the default action' do
    expect(chef_run).to install_pacman_package('default_action')
    expect(chef_run).to_not install_pacman_package('not_default_action')
  end

  it 'installs a pacman_package with an explicit action' do
    expect(chef_run).to install_pacman_package('explicit_action')
  end

  it 'installs a pacman_package with attributes' do
    expect(chef_run).to install_pacman_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_pacman_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a pacman_package when specifying the identity attribute' do
    expect(chef_run).to install_pacman_package('identity_attribute')
  end
end

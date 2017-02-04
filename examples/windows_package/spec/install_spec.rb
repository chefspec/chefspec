require 'chefspec'

describe 'windows_package::install' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'installs a windows_package with an explicit action' do
    expect(chef_run).to install_windows_package('explicit_action')
    expect(chef_run).to_not install_windows_package('not_explicit_action')
  end

  it 'installs a windows_package with attributes' do
    expect(chef_run).to install_windows_package('with_attributes').with(installer_type: :msi)
    expect(chef_run).to_not install_windows_package('with_attributes').with(installer_type: 'bacon')
  end

  it 'installs a windows_package when specifying the identity attribute' do
    expect(chef_run).to install_windows_package('identity_attribute')
  end
end

require 'chefspec'

describe 'freebsd_package::install' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'freebsd', version: '11.0')
                          .converge(described_recipe)
  end

  it 'installs a freebsd_package with the default action' do
    expect(chef_run).to install_freebsd_package('default_action')
    expect(chef_run).to_not install_freebsd_package('not_default_action')
  end

  it 'installs a freebsd_package with an explicit action' do
    expect(chef_run).to install_freebsd_package('explicit_action')
  end

  it 'installs a freebsd_package with attributes' do
    expect(chef_run).to install_freebsd_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not install_freebsd_package('with_attributes').with(version: '1.2.3')
  end

  it 'installs a freebsd_package when specifying the identity attribute' do
    expect(chef_run).to install_freebsd_package('identity_attribute')
  end
end

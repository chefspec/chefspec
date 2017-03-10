require 'chefspec'

describe 'roles' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge('role[role]') }

  it 'expands the run_list' do
    expect(chef_run).to include_recipe('roles::default')
    expect(chef_run).to include_recipe('roles::another')
    expect(chef_run).to_not include_recipe('roles::not_recipe')
  end

  it 'installs the package' do
    expect(chef_run).to install_package('resource')
    expect(chef_run).to_not install_package('not_resource')
  end

  it 'installs the service' do
    expect(chef_run).to start_service('resource')
    expect(chef_run).to_not start_service('not_resource')
  end
end

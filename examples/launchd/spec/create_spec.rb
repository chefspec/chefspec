require 'chefspec'

describe 'launchd::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'creates a launchd daemon with an explicit action' do
    expect(chef_run).to create_launchd('explicit_action')
    expect(chef_run).to_not create_launchd('not_explicit_action')
  end

  it 'creates a launchd daemon with a default_action action' do
    expect(chef_run).to create_launchd('default_action')
  end
end

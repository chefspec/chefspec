require 'chefspec'

describe 'launchd::create_if_missing' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'creates a launchd daemon if missing with an explicit action' do
    expect(chef_run).to create_if_missing_launchd('explicit_action')
    expect(chef_run).to_not create_if_missing_launchd('not_explicit_action')
  end
end

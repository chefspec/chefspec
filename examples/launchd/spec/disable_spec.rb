require 'chefspec'

describe 'launchd::disable' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'disables a launchd daemon with an explicit action' do
    expect(chef_run).to disable_launchd('explicit_action')
    expect(chef_run).to_not disable_launchd('not_explicit_action')
  end
end

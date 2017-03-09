require 'chefspec'

describe 'launchd::enable' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12').converge(described_recipe) }

  it 'enables a launchd daemon with an explicit action' do
    expect(chef_run).to enable_launchd('explicit_action')
    expect(chef_run).to_not enable_launchd('not_explicit_action')
  end
end

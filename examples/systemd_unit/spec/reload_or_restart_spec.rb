require 'chefspec'

describe 'systemd_unit::reload_or_restart' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'reloads or restarts a systemd_unit daemon with an explicit action' do
    expect(chef_run).to reload_or_restart_systemd_unit('explicit_action')
    expect(chef_run).to_not reload_or_restart_systemd_unit('not_explicit_action')
  end
end

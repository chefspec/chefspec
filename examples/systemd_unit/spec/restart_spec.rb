require 'chefspec'

describe 'systemd_unit::restart' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'restarts a systemd_unit daemon with an explicit action' do
    expect(chef_run).to restart_systemd_unit('explicit_action')
    expect(chef_run).to_not restart_systemd_unit('not_explicit_action')
  end
end

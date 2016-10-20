require 'chefspec'

describe 'systemd_unit::try_restart' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'tries to restart a systemd_unit daemon with an explicit action' do
    expect(chef_run).to try_restart_systemd_unit('explicit_action')
    expect(chef_run).to_not try_restart_systemd_unit('not_explicit_action')
  end
end

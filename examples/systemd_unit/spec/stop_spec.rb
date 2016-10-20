require 'chefspec'

describe 'systemd_unit::stop' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'stops a systemd_unit daemon with an explicit action' do
    expect(chef_run).to stop_systemd_unit('explicit_action')
    expect(chef_run).to_not stop_systemd_unit('not_explicit_action')
  end
end

require 'chefspec'

describe 'systemd_unit::disable' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'disables a systemd unit with an explicit action' do
    expect(chef_run).to disable_systemd_unit('explicit_action')
    expect(chef_run).to_not disable_systemd_unit('not_explicit_action')
  end
end

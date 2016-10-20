require 'chefspec'

describe 'systemd_unit::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a systemd unit with an explicit action' do
    expect(chef_run).to create_systemd_unit('explicit_action')
    expect(chef_run).to_not create_systemd_unit('not_explicit_action')
  end
end

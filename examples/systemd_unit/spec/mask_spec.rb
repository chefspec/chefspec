require 'chefspec'

describe 'systemd_unit::mask' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'masks a systemd unit with an explicit action' do
    expect(chef_run).to mask_systemd_unit('explicit_action')
    expect(chef_run).to_not mask_systemd_unit('not_explicit_action')
  end
end

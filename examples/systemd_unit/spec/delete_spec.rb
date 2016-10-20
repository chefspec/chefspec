require 'chefspec'

describe 'systemd_unit::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a systemd_unit with an explicit action' do
    expect(chef_run).to delete_systemd_unit('explicit_action')
    expect(chef_run).to_not delete_systemd_unit('not_explicit_action')
  end
end

require 'chefspec'

describe 'launchd::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.11.1').converge(described_recipe) }

  it 'deletes a launchd with an explicit action' do
    expect(chef_run).to delete_launchd('explicit_action')
    expect(chef_run).to_not delete_launchd('not_explicit_action')
  end
end

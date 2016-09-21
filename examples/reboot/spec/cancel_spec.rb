require 'chefspec'

describe 'reboot::cancel' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'runs a cancel_reboot' do
    expect(chef_run).to cancel_reboot('explicit cancel')
  end
end

require 'chefspec'

describe 'reboot::request' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'runs a request_reboot' do
    expect(chef_run).to request_reboot('explicit_action')
  end
end

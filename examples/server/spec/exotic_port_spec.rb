require 'chefspec'

describe 'server::port' do
  before(:all) do
    @oldsetting = RSpec.configuration.server_runner_port
    RSpec.configuration.server_runner_port = (8900..8910)
    ChefSpec::ZeroServer.nuke!
    ChefSpec::ZeroServer.setup!
  end

  after(:all) do
    RSpec.configuration.server_runner_port = @oldsetting
    ChefSpec::ZeroServer.nuke!
    ChefSpec::ZeroServer.setup!
  end

  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '18.04')
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'creates a chef-zero listening on the right port' do
    expect(ChefSpec::ZeroServer.server).to be_running
    expect(ChefSpec::ZeroServer.server.port).to be_a(Integer)
    expect(8890..9010).to include(ChefSpec::ZeroServer.server.port)
  end
end

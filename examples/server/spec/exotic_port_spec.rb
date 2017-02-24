require 'chefspec'

describe 'server::port' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'creates a chef-zero listening on the right port' do
    expect(ChefSpec::ZeroServer.server).to be_running?
    expect(ChefSpec::ZeroServer.server.port).to be_a(Integer)
    expect(8900..9010).to include(ChefSpec::ZeroServer.server.port)
  end
end

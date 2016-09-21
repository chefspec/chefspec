require 'chefspec'

describe 'server::role' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |_node, server|
      server.create_role('webserver')
    end.converge(described_recipe)
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for roles' do
    expect(chef_run).to write_log('roles')
      .with_message('role[webserver]')
  end
end

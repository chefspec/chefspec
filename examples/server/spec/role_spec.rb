require 'chefspec'
require 'chefspec/server'

describe 'server::role' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for roles' do
    ChefSpec::Server.create_role('webserver')

    expect(chef_run).to write_log('roles')
      .with_message('role[webserver]')
  end
end

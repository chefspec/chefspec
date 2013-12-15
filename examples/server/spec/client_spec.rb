require 'chefspec'
load 'chefspec/server.rb'

describe 'server::client' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for clients' do
    ChefSpec::Server.create_client('bacon', { name: 'bacon' })

    expect(chef_run).to write_log('clients')
      .with_message('client[bacon], client[chef-validator], client[chef-webui]')
  end
end

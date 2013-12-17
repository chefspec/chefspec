require 'chefspec'
load 'chefspec/server.rb'

describe 'server::node' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for nodes' do
    ChefSpec::Server.create_node('bacon', { name: 'bacon' })

    expect(chef_run).to write_log('nodes')
      .with_message('node[bacon], node[chefspec]')
  end

  it 'searches for nodes with fqdn' do
    expect(chef_run).to write_log('nodenames')
      .with_message(/chefspec.local/)
  end
end

require 'chefspec'
load 'chefspec/server.rb'

describe 'server::node' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  before do
    ChefSpec::Server.create_node(
      'bacon',
      stub_node(
        'bacon',
        platform: 'ubuntu',
        version: '12.04',
        ohai: { fqdn:'bacon.example.com' }
      )
    )
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for nodes' do
    expect(chef_run).to write_log('nodes')
      .with_message('node[bacon], node[chefspec]')
  end

  it 'searches for nodes with fqdn chefspec.local (the own client during chefspec-run)' do
    expect(chef_run).to write_log('nodenames')
      .with_message(/chefspec.local/)
  end
  it 'searches for nodes with fqdn bacon.example.com' do
    expect(chef_run).to write_log('nodenames')
      .with_message(/bacon.example.com/)
  end
end

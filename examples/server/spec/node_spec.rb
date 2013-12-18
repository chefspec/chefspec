require 'chefspec'
load 'chefspec/server.rb'

describe 'server::node' do

  context 'one simple extra node to be found,' do

    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'do not raise an exception' do
      expect { chef_run }.to_not raise_error
    end

    it 'search the Chef Server for nodes' do
      ChefSpec::Server.create_node('bacon', { name: 'bacon'})

      expect(chef_run).to write_log('nodes')
        .with_message('node[bacon], node[chefspec]')
    end

  end
  context 'two additional nodes with fauxhai-data,' do

    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    before do
      ChefSpec::Server.create_node(
        'ham',
        stub_node(
          'ham',
          platform: 'debian',
          version: '7.1',
          ohai: { fqdn:'ham.example.com' }
        )
      )
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

    it 'search for all nodes' do
      expect(chef_run).to write_log('nodes')
        .with_message('node[bacon], node[chefspec], node[ham]')
    end

    it 'search for all nodes with domain-part .example.com' do
      expect(chef_run).to write_log('examplenodes')
        .with_message('bacon.example.com, ham.example.com')
    end
  end
end

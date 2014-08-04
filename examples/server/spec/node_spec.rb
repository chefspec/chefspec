require 'chefspec'
require 'chefspec/server'

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

  context 'with custom Ohai data' do
    it 'has the node data' do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
        .converge(described_recipe)

      expect(ChefSpec::Server).to have_node('chefspec')

      node = ChefSpec::Server.node('chefspec')
      expect(node['kernel']['name']).to eq('Linux')
      expect(node['kernel']['release']).to eq('3.2.0-26-generic')
      expect(node['kernel']['machine']).to eq('x86_64')
    end
  end

  context 'with overridden node data' do
    it 'has the node data' do
      ChefSpec::Runner.new { |node| node.set['breakfast']['bacon'] = true }
        .converge(described_recipe)

      expect(ChefSpec::Server).to have_node('chefspec')

      node = ChefSpec::Server.node('chefspec')
      expect(node['breakfast']['bacon']).to be_truthy
    end
  end
end

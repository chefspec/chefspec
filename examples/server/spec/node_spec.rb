require 'chefspec'

describe 'server::node' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      server.create_node('bacon', { name: 'bacon' })
    end.converge(described_recipe)
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for nodes' do
    expect(chef_run).to write_log('nodes')
      .with_message('node[bacon], node[chefspec]')
  end

  context 'with custom Ohai data' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
        .converge(described_recipe)
    end

    it 'has the node data' do
      expect(chef_run).to have_node('chefspec')

      node = chef_run.get_node('chefspec')
      expect(node['kernel']['name']).to eq('Linux')
      expect(node['kernel']['release']).to eq('3.13.0-66-generic')
      expect(node['kernel']['machine']).to eq('x86_64')
    end
  end

  context 'with overridden node data' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node, server|
        node.set['breakfast']['bacon'] = true
      end.converge(described_recipe)
    end

    it 'has the node data' do
      expect(chef_run).to have_node('chefspec')

      node = chef_run.get_node('chefspec')
      expect(node['breakfast']['bacon']).to be true
    end
  end
end

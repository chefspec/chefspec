require 'chefspec'

describe 'server::node' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |_node, server|
      server.create_node('bacon', name: 'bacon')
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
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                            .converge(described_recipe)
    end

    it 'has the node data' do
      expect(chef_run).to have_node('chefspec')

      node = chef_run.get_node('chefspec')
      expect(node['kernel']['name']).to eq('Linux')
      expect(node['kernel']['release']).to match(/4.4.0-.*-generic/) # avoid failing when fauxhai data changes
      expect(node['kernel']['machine']).to eq('x86_64')
    end
  end

  context 'with overridden node data' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node, _server|
        node.normal['breakfast']['bacon'] = true
      end.converge(described_recipe)
    end

    it 'has the node data' do
      expect(chef_run).to have_node('chefspec')

      node = chef_run.get_node('chefspec')
      expect(node['breakfast']['bacon']).to be true
    end
  end
end

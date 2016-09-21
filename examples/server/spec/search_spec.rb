require 'chefspec'

describe 'server::search' do
  let(:node_1) do
    stub_node('node_1') do |node|
      node.automatic['hostname'] = 'node_1'
      node.automatic['fqdn'] = 'node_1.example.com'
      node.normal['bar'] = true
    end
  end

  let(:node_2) do
    stub_node('node_2') do |node|
      node.automatic['hostname'] = 'node_2'
      node.automatic['fqdn'] = 'node_2.example.com'
      node.normal['bar'] = true
    end
  end

  let(:node_3) do
    stub_node('node_3') do |node|
      node.automatic['hostname'] = 'node_3'
      node.automatic['fqdn'] = 'node_3.example.com'
      node.normal['bar'] = true
    end
  end

  let(:node_4) do
    stub_node('node_4') do |node|
      node.automatic['hostname'] = 'node_4'
      node.automatic['fqdn'] = 'node_4.example.com'
    end
  end

  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node, server|
      node.normal['bar'] = true
      server.update_node(node)

      server.create_node(node_1)
      server.create_node(node_2)
      server.create_node(node_3)
      server.create_node(node_4)
    end.converge(described_recipe)
  end

  it 'finds all nodes with the bar attribute' do
    expect(chef_run).to write_log('nodes with an attribute')
      .with_message(<<-EOH.gsub(/^ {8}/, '').strip)
        chefspec, FQDN: fauxhai.local, hostname: Fauxhai
        node_1, FQDN: node_1.example.com, hostname: node_1
        node_2, FQDN: node_2.example.com, hostname: node_2
        node_3, FQDN: node_3.example.com, hostname: node_3
      EOH
  end

  it 'does not find the node without the bar attribute' do
    expect(chef_run).to_not write_log('nodes with an attribute')
      .with_message(/node_4/)
  end
end

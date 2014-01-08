require 'chefspec'
require 'chefspec/server'

describe 'server_search::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  let(:node_1) do
    stub_node('node_1') do |node|
      node.automatic['hostname'] = 'node_1'
      node.automatic['fqdn'] = 'node_1.example.com'
      node.set['bar'] = true
    end
  end

  let(:node_2) do
    stub_node('node_2') do |node|
      node.automatic['hostname'] = 'node_2'
      node.automatic['fqdn'] = 'node_2.example.com'
      node.set['bar'] = true
    end
  end

  let(:node_3) do
    stub_node('node_3') do |node|
      node.automatic['hostname'] = 'node_3'
      node.automatic['fqdn'] = 'node_3.example.com'
      node.set['bar'] = true
    end
  end

  let(:node_4) do
    stub_node('node_4') do |node|
      node.automatic['hostname'] = 'node_4'
      node.automatic['fqdn'] = 'node_4.example.com'
    end
  end

  before do
    ChefSpec::Server.create_node(node_1)
    ChefSpec::Server.create_node(node_2)
    ChefSpec::Server.create_node(node_3)
    ChefSpec::Server.create_node(node_4)
  end

  it 'finds all nodes with the bar attribute' do
    expect(chef_run).to write_log('nodes with an attribute')
      .with_message(<<-EOH.gsub(/^ {8}/, '').strip)
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

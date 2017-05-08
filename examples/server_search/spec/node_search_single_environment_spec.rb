require 'chefspec'
require 'chefspec/server'

describe 'node_search_single_environment' do

  before do
    ## totally not working...
    #ChefSpec::Server.create_node(
    #  'bacon',
    #  stub_node(
    #    'bacon',
    #    platform: 'ubuntu',
    #    version: '12.04',
    #    ohai: { bar: 'was here', 'fqdn' => 'bacon.example.com' }
    #  ).to_hash
    #)

    ## Works but doesn't set the fqdn (nor the hostname or the domain)
    bacon = stub_node(
      'bacon',
      platform: 'ubuntu',
      version: '12.04'
    ) do |node|
      node.set['fqdn'] = 'bacon.example.com'
      node.set['bar'] = 'bar was here'
      node.set['domain'] = 'example.com'
      node.automatic['hostname'] = 'bacon'
    end
    bacon.set['hostname'] = 'bacon'
    puts bacon
    puts bacon[:fqdn]
    puts bacon['fqdn']
    #puts bacon.to_hash
    ChefSpec::Server.create_node('bacon', bacon.to_hash)

    # Should create another node 'ham' with attribute and recipe 'bar'
    ham = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04', ohai: {'fqdn' => 'ham.example.com' }) do |node|
      node.set['fqdn'] = 'ham.example.com'
      node.set['hostname'] = 'ham'
      node.set['domain'] = 'example.com'
    end
    ham.converge('server_search::bar')
    puts ham.node[:fqdn]
    puts ham.node['fqdn']
    ChefSpec::Server.create_node('ham', ham.node.to_hash)
    # Should create another node 'tomato' without attributes and recipes
  end

  let(:chef_run) { ChefSpec::Runner.new.converge('server_search::foo') }

  context 'searches for all nodes with recipe bar' do
    it 'finds nodes bacon and ham' do
      expect(chef_run).to write_log('recipesearch')
        .with_message(/bacon/)
      expect(chef_run).to write_log('recipesearch')
        .with_message(/bacon.example.com/)
      expect(chef_run).to write_log('recipesearch')
        .with_message(/ham/)
      expect(chef_run).to write_log('recipesearch')
        .with_message(/ham.example.com/)
    end

    it 'does not find node tomato' do
      expect(chef_run).not_to write_log('recipesearch')
        .with_message(/tomato/)
    end
  end

  context 'searches for all nodes with attribute bar' do
    it 'finds nodes bacon and ham' do
      expect(chef_run).to write_log('attributesearch')
        .with_message(/bacon/)
      expect(chef_run).to write_log('attributesearch')
        .with_message(/bacon.example.com/)
      expect(chef_run).to write_log('attributesearch')
        .with_message(/ham/)
      expect(chef_run).to write_log('attributesearch')
        .with_message(/ham.example.com/)
    end

    it 'does not find node tomato' do
      expect(chef_run).not_to write_log('attributesearch')
        .with_message(/tomato/)
    end
  end

end

require 'spec_helper'

describe ChefSpec::API::Stubs do
  describe '#stub_command' do
    let(:command_stub) { double('command') }

    it 'adds the command to the command registry' do
      allow(ChefSpec::Stubs::CommandStub).to receive(:new).and_return(command_stub)
      stub_command('echo "hello"')

      expect(ChefSpec::Stubs::CommandRegistry.stubs).to include(command_stub)
    end
  end

  describe '#stub_search' do
    let(:search_stub) { double('search') }

    it 'adds the query to the search registry' do
      allow(ChefSpec::Stubs::SearchStub).to receive(:new).and_return(search_stub)
      stub_search(:node, '*:*')

      expect(ChefSpec::Stubs::SearchRegistry.stubs).to include(search_stub)
    end
  end

  describe '#stub_data_bag' do
    let(:data_bag_stub) { double('data_bag') }

    it 'adds the query to the data_bag registry' do
      allow(ChefSpec::Stubs::DataBagStub).to receive(:new).and_return(data_bag_stub)
      stub_data_bag(:users)

      expect(ChefSpec::Stubs::DataBagRegistry.stubs).to include(data_bag_stub)
    end
  end

  describe '#stub_data_bag_item' do
    let(:data_bag_item_stub) { double('data_bag_item') }

    it 'adds the query to the data_bag_item registry' do
      allow(ChefSpec::Stubs::DataBagItemStub).to receive(:new).and_return(data_bag_item_stub)
      stub_data_bag_item(:users, 'id')

      expect(ChefSpec::Stubs::DataBagItemRegistry.stubs).to include(data_bag_item_stub)
    end
  end

  describe '#stub_node' do
    it 'returns a Chef::Node' do
      expect(stub_node).to be_a(Chef::Node)
    end

    it 'defaults the node name to `node.example`' do
      node = stub_node
      expect(node.name).to eq('node.example')
    end

    it 'sets the node name when given' do
      node = stub_node('example.com')
      expect(node.name).to eq('example.com')
    end

    it 'sets the automatic attributes' do
      node = stub_node
      expect(node.automatic).to eq(Fauxhai.mock.data)
    end

    it 'sets the automatic attributes with ohai overrides' do
      node = stub_node('node.example', ohai: { ipaddress: '1.2.3.4' })
      expect(node['ipaddress']).to eq('1.2.3.4')
    end

    it 'sets the automatic attributes for a specific platform and version' do
      node = stub_node('node.example', platform: 'ubuntu', version: '18.04')
      expect(node.automatic).to eq(Fauxhai.mock(platform: 'ubuntu', version: '18.04').data)
    end

    it 'sets the automatic attributes from a JSON data path' do
      allow(File).to receive(:exist?).with('/path/to/json').and_return(true)
      allow(File).to receive(:read).with('/path/to/json').and_return('{ "ipaddress": "1.2.3.4" }')
      node = stub_node('node.example', path: '/path/to/json')
      expect(node['ipaddress']).to eq('1.2.3.4')
    end

    it 'yields a block' do
      expect { |block| stub_node(&block) }.to yield_with_args(Chef::Node)
    end
  end
end

describe 'nginx::source' do
  describe '#described_cookbook' do
    describe 'nginx::source' do
      it 'returns the name of the cookbook' do
        expect(described_cookbook).to eq('nginx')
      end

      context 'in a nested context' do
        it 'still returns the name of the cookbook' do
          expect(described_cookbook).to eq('nginx')
        end
      end
    end
  end

  describe '#described_recipe' do
    describe 'nginx::source' do
      it 'returns the cookbook::recipe' do
        expect(described_recipe).to eq('nginx::source')
      end

      context 'in a nested context' do
        it 'still retrns the cookbook::recipe' do
          expect(described_recipe).to eq('nginx::source')
        end
      end
    end
  end
end

require 'chefspec'

describe 'stub_search::block' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  context 'when the search is not stubbed' do
    it 'raises an exception' do
      expect do
        chef_run
      end.to raise_error(ChefSpec::Error::SearchNotStubbed)
    end
  end

  context 'as a String' do
    it 'does not raise an exception' do
      stub_search(:node, 'roles:web').and_return([{ name: 'example.com' }])
      expect { chef_run }.to_not raise_error
    end
  end

  context 'as a Regexp' do
    it 'does not raise an exception' do
      stub_search(:node, /roles:(.+)/).and_return([{ name: 'example.com' }])
      expect { chef_run }.to_not raise_error
    end
  end
end

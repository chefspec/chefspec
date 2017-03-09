require 'chefspec'

describe 'stub_data_bag::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  context 'when the data_bag is not stubbed' do
    it 'raises an exception' do
      expect do
        chef_run
      end.to raise_error(ChefSpec::Error::DataBagNotStubbed)
    end
  end

  context 'as a String' do
    it 'does not raise an exception' do
      stub_data_bag('users').and_return(['svargo'])
      expect { chef_run }.to_not raise_error
    end
  end

  context 'as a Symbol' do
    it 'does not raise an exception' do
      stub_data_bag(:users).and_return(['svargo'])
      expect { chef_run }.to_not raise_error
    end
  end
end

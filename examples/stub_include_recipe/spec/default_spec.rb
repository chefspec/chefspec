require 'chefspec'

describe 'stub_include_recipe::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  context 'when include_recipe is not stubbed' do
    it 'raises an exception' do
      expect {
        chef_run
      }.to raise_error(ChefSpec::Error::IncludeRecipeNotStubbed)
    end
  end

  context 'as a String' do
    it 'does not raise an exception' do
      stub_include_recipe('cookbook::baggage')
      expect(chef_run).to include_recipe('cookbook::baggage')
    end
  end
end

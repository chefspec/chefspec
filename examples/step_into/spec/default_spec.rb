require 'chefspec'

describe 'step_into::default' do
  context 'without :step_into' do
    let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    it 'does not execute the LWRPs action' do
      expect(chef_run).to_not write_log('message')
    end
  end

  context 'with :step_into' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['step_into_lwrp'])
        .converge(described_recipe)
      end

    it 'does execute the LWRPs action' do
      expect(chef_run).to write_log('message')
    end
  end
end

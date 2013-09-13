require 'chefspec'

describe 'step_into::default' do
  context 'without :step_into' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'does not execute the LWRPs action' do
      expect(chef_run).to_not write_log('message')
    end
  end

  context 'with :step_into' do
    let(:chef_run) { ChefSpec::Runner.new(step_into: ['step_into_lwrp']).converge(described_recipe) }

    it 'does execute the LWRPs action' do
      expect(chef_run).to write_log('message')
    end
  end
end

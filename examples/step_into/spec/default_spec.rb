require 'chefspec'

describe 'step_into::default' do
  context 'without :step_into' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

    it 'does not execute the LWRPs action' do
      expect(chef_run).to_not write_log('message')
    end

    it 'does not execute the custom LWRPs action' do
      expect(chef_run).to_not write_log('custom message')
    end
  end

  context 'with :step_into' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: %w(step_into_lwrp provides_this))
                            .converge(described_recipe)
    end

    it 'executes the LWRPs action' do
      expect(chef_run).to write_log('message')
    end

    it 'executes the custom LWRPs action' do
      expect(chef_run).to write_log('custom message')
    end
  end
end

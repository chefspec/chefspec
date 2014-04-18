require 'chefspec'

describe 'stub_environment::default' do

  context 'when the chef_environment is not stubbed' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
    it 'raises an exception' do
      expect {
        chef_run
      }.to raise_error(Chef::Exceptions::EnvironmentNotFound)
    end
  end

  context 'as a String' do
    let(:chef_run) { 
      stub_environment('development')
      ChefSpec::Runner.new.converge(described_recipe)
    }
    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'as a Symbol' do
    let(:chef_run) { 
      stub_environment(:development)
      ChefSpec::Runner.new.converge(described_recipe)
    }
    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'within an it block' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
    it 'does not raise an exception' do
      stub_environment('development')
      expect { chef_run }.to_not raise_error
    end
  end
end

require 'chefspec'

describe 'stub_environment::default' do

  context 'when the chef_environment is not stubbed' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'raises an exception' do
      expect do
        chef_run
      end.to raise_error(StandardError, 'Environment not stubbed')
    end
  end

  context 'as a String' do
    let(:chef_run) do
      stub_environment('development')
      ChefSpec::Runner.new.converge(described_recipe)
    end

    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'as a Symbol' do
    let(:chef_run) do
      stub_environment(:development)
      ChefSpec::Runner.new.converge(described_recipe)
    end

    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
    it 'should set node.environment' do
      expect(chef_run).to write_log('node.environment=development')
    end
    it 'should set node.chef_environment' do
      expect(chef_run).to write_log('node.chef_environment=development')
    end
  end

  context 'within an it block' do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'does not raise an exception' do
      stub_environment('development')
      expect { chef_run }.to_not raise_error
    end
    it 'should set node.environment' do
      stub_environment('staging')
      expect(chef_run).to write_log('node.environment=staging')
    end
    it 'should set node.chef_environment' do
      stub_environment('production')
      expect(chef_run).to write_log('node.chef_environment=production')
    end
  end

  context 'within the ChefSpec::Runner block' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        stub_environment('development')
      end.converge(described_recipe)
    end

    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
    it 'should set node.environment' do
      expect(chef_run).to write_log('node.environment=development')
    end
    it 'should set node.chef_environment' do
      expect(chef_run).to write_log('node.chef_environment=development')
    end
  end

  context 'when passing a block to stub_environment' do
    let(:chef_run) do
      stub_environment('development') do
        default_attributes('foo' => 'bar')
      end
      ChefSpec::Runner.new.converge(described_recipe)
    end

    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
    it 'should set node.environment' do
      expect(chef_run).to write_log('node.environment=development')
    end
    it 'should set node.chef_environment' do
      expect(chef_run).to write_log('node.chef_environment=development')
    end
    it 'should set node.foo' do
      expect(chef_run).to write_log('node.foo=bar')
    end
  end
end

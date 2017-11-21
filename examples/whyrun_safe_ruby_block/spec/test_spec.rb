require 'chefspec'

describe 'whyrun_safe_ruby_block::test' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: %w(whyrun_safe_ruby_block))
    runner.converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'has a ruby_block named foo' do
    expect(chef_run).to run_ruby_block('foo')
  end

  it 'has a whyrun_ruby_block named baz' do
    expect(chef_run).to run_whyrun_safe_ruby_block('baz')
  end
end

require 'chefspec'

describe 'whyrun_safe_ruby_block::test' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
    runner.converge(described_recipe)
    if runner.find_resources(:whyrun_safe_ruby_block)
      runner.find_resources(:whyrun_safe_ruby_block).each do |resource|
        resource.old_run_action(:create)
      end
    end
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end

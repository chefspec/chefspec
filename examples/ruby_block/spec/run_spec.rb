require 'chefspec'

describe 'ruby_block::run' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'runs a ruby_block with the default action' do
    expect(chef_run).to run_ruby_block('default_action')
    expect(chef_run).to_not run_ruby_block('not_default_action')
  end

  it 'runs a ruby_block with an explicit action' do
    expect(chef_run).to run_ruby_block('explicit_action')
  end

  it 'runs a ruby_block when specifying the identity attribute' do
    expect(chef_run).to run_ruby_block('identity_attribute')
  end
end

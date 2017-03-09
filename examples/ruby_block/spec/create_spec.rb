require 'chefspec'

describe 'ruby_block::create' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a ruby_block with an explicit action' do
    expect(chef_run).to create_ruby_block('explicit_action')
  end

  it 'creates a ruby_block when specifying the identity attribute' do
    expect(chef_run).to create_ruby_block('identity_attribute')
  end
end

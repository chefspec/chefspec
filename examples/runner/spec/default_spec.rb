# A simple test to make sure the ChefSpec::Runner name works.

require 'chefspec'

describe 'runner' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  it 'runs the recipe' do
    expect(chef_run).to write_log('worked')
  end
end

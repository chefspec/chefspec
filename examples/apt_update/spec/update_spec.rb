require 'chefspec'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version  = '16.04'
end

describe 'apt_update::update' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'updates apt repo' do
    expect(chef_run).to update_apt_update('update_repo')
  end
end

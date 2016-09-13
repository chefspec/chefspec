require 'chefspec'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version  = '16.04'
end

describe 'apt_update::periodic' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'updates apt with default action' do
    expect(chef_run).to periodic_apt_update('default_action')
    expect(chef_run).to_not periodic_apt_update('not_default_action')
  end

  it 'installs an apt_repository with an explicit action' do
    expect(chef_run).to periodic_apt_update('explicit_action')
  end
end

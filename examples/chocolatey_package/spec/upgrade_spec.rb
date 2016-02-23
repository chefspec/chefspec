require 'chefspec'

RSpec.configure do |config|
  config.platform = 'windows'
  config.version  = '2012R2'
end

describe 'chocolatey_package::upgrade' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'upgrades a package' do
    expect(chef_run).to upgrade_chocolatey_package('7zip')
  end

  it 'upgrades a specific version of a package with options' do
    expect(chef_run).to upgrade_chocolatey_package('git').with(
      version: %w(2.7.1)
    )
  end
end

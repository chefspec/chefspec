require 'chefspec'

RSpec.configure do |config|
  config.platform = 'windows'
  config.version  = '2012R2'
end

describe 'chocolatey_package::remove' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'removes a package' do
    expect(chef_run).to remove_chocolatey_package('7zip')
  end

  it 'removes a specific version of a package with options' do
    expect(chef_run).to remove_chocolatey_package('git').with(
      version: %w(2.7.1)
    )
  end
end

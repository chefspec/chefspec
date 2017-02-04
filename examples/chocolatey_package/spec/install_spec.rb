require 'chefspec'

describe 'chocolatey_package::install' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'installs a package' do
    expect(chef_run).to install_chocolatey_package('7zip')
  end

  it 'installs a specific version of a package with options' do
    expect(chef_run).to install_chocolatey_package('git').with(
      version: %w(2.7.1),
      options: '--params /GitAndUnixToolsOnPath'
    )
  end
end

require 'chefspec'

describe 'package::install' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs a package with the default action' do
    expect(chef_run).to install_package('default_action')
  end

  it 'installs a package with an explicit action' do
    expect(chef_run).to install_package('explicit_action')
  end

  it 'installs a package with attributes' do
    expect(chef_run).to install_package('with_attributes').with(version: '1.0.0')
  end

  it 'installs a package when specifying the identity attribute' do
    expect(chef_run).to install_package('identity_attribute')
  end
end

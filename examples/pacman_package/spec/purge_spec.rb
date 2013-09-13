require 'chefspec'

describe 'pacman_package::purge' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'purges a pacman_package with an explicit action' do
    expect(chef_run).to purge_pacman_package('explicit_action')
  end

  it 'purges a pacman_package with attributes' do
    expect(chef_run).to purge_pacman_package('with_attributes').with(version: '1.0.0')
  end

  it 'purges a pacman_package when specifying the identity attribute' do
    expect(chef_run).to purge_pacman_package('identity_attribute')
  end
end

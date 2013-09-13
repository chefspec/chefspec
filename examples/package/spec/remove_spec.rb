require 'chefspec'

describe 'package::remove' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'removes a package with an explicit action' do
    expect(chef_run).to remove_package('explicit_action')
  end

  it 'removes a package with attributes' do
    expect(chef_run).to remove_package('with_attributes').with(version: '1.0.0')
  end

  it 'removes a package when specifying the identity attribute' do
    expect(chef_run).to remove_package('identity_attribute')
  end
end

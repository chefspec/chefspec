require 'chefspec'

describe 'package::unlock' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'unlocks a package with an explicit action' do
    expect(chef_run).to unlock_package('explicit_action')
    expect(chef_run).to_not unlock_package('not_explicit_action')
  end

  it 'unlocks a package with attributes' do
    expect(chef_run).to unlock_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not unlock_package('with_attributes').with(version: '1.2.3')
  end

  it 'unlocks a package when specifying the identity attribute' do
    expect(chef_run).to unlock_package('identity_attribute')
  end

  it 'unlocks all packages when given an array of names' do
    expect(chef_run).to unlock_package(%w(with array))
  end
end

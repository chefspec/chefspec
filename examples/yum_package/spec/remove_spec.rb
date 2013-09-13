require 'chefspec'

describe 'yum_package::remove' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'removes a yum_package with an explicit action' do
    expect(chef_run).to remove_yum_package('explicit_action')
  end

  it 'removes a yum_package with attributes' do
    expect(chef_run).to remove_yum_package('with_attributes').with(version: '1.0.0')
  end

  it 'removes a yum_package when specifying the identity attribute' do
    expect(chef_run).to remove_yum_package('identity_attribute')
  end
end

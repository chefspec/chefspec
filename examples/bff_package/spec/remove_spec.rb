require 'chefspec'

describe 'bff_package::remove' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'aix', version: '7.1').converge(described_recipe) }

  it 'removes a bff_package with an explicit action' do
    expect(chef_run).to remove_bff_package('explicit_action')
    expect(chef_run).to_not remove_bff_package('not_explicit_action')
  end

  it 'removes a bff_package with attributes' do
    expect(chef_run).to remove_bff_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not remove_bff_package('with_attributes').with(version: '1.2.3')
  end

  it 'removes a bff_package when specifying the identity attribute' do
    expect(chef_run).to remove_bff_package('identity_attribute')
  end
end

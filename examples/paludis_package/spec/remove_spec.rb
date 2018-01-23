require 'chefspec'

describe 'paludis_package::remove' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'gentoo', version: '4.9.6-gentoo-r1').converge(described_recipe) }

  it 'removes a paludis_package with an explicit action' do
    expect(chef_run).to remove_paludis_package('explicit_action')
    expect(chef_run).to_not remove_paludis_package('not_explicit_action')
  end

  it 'removes a paludis_package with attributes' do
    expect(chef_run).to remove_paludis_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not remove_paludis_package('with_attributes').with(version: '1.2.3')
  end

  it 'removes a paludis_package when specifying the identity attribute' do
    expect(chef_run).to remove_paludis_package('identity_attribute')
  end
end

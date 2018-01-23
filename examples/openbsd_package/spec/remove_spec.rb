require 'chefspec'

describe 'openbsd_package::remove' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'openbsd', version: '6.2').converge(described_recipe) }

  it 'removes a openbsd_package with an explicit action' do
    expect(chef_run).to remove_openbsd_package('explicit_action')
    expect(chef_run).to_not remove_openbsd_package('not_explicit_action')
  end

  it 'removes a openbsd_package with attributes' do
    expect(chef_run).to remove_openbsd_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not remove_openbsd_package('with_attributes').with(version: '1.2.3')
  end

  it 'removes a openbsd_package when specifying the identity attribute' do
    expect(chef_run).to remove_openbsd_package('identity_attribute')
  end
end

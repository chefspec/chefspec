require 'chefspec'

describe 'zypper_package::purge' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'opensuse', version: '42.1').converge(described_recipe) }

  it 'purges a zypper_package with an explicit action' do
    expect(chef_run).to purge_zypper_package('explicit_action')
    expect(chef_run).to_not purge_zypper_package('not_explicit_action')
  end

  it 'purges a zypper_package with attributes' do
    expect(chef_run).to purge_zypper_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not purge_zypper_package('with_attributes').with(version: '1.2.3')
  end

  it 'purges a zypper_package when specifying the identity attribute' do
    expect(chef_run).to purge_zypper_package('identity_attribute')
  end
end

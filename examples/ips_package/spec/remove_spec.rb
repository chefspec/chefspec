require 'chefspec'

RSpec.configure do |config|
  config.platform = 'solaris2'
  config.version  = '5.11'
end

describe 'ips_package::remove' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'removes a ips_package with an explicit action' do
    expect(chef_run).to remove_ips_package('explicit_action')
    expect(chef_run).to_not remove_ips_package('not_explicit_action')
  end

  it 'removes a ips_package with attributes' do
    expect(chef_run).to remove_ips_package('with_attributes').with(version: '1.0.0')
    expect(chef_run).to_not remove_ips_package('with_attributes').with(version: '1.2.3')
  end

  it 'removes a ips_package when specifying the identity attribute' do
    expect(chef_run).to remove_ips_package('identity_attribute')
  end
end

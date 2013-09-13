require 'chefspec'

describe 'freebsd_package::remove' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'removes a freebsd_package with an explicit action' do
    expect(chef_run).to remove_freebsd_package('explicit_action')
  end

  it 'removes a freebsd_package with attributes' do
    expect(chef_run).to remove_freebsd_package('with_attributes').with(version: '1.0.0')
  end

  it 'removes a freebsd_package when specifying the identity attribute' do
    expect(chef_run).to remove_freebsd_package('identity_attribute')
  end
end

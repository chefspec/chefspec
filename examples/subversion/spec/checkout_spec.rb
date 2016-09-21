require 'chefspec'

describe 'subversion::checkout' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'checkouts a subversion with an explicit action' do
    expect(chef_run).to checkout_subversion('/tmp/explicit_action')
    expect(chef_run).to_not checkout_subversion('/tmp/not_explicit_action')
  end

  it 'checkouts a subversion with attributes' do
    expect(chef_run).to checkout_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
    expect(chef_run).to_not checkout_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path')
  end

  it 'checkouts a subversion when specifying the identity attribute' do
    expect(chef_run).to checkout_subversion('/tmp/identity_attribute')
  end
end

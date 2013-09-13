require 'chefspec'

describe 'subversion::checkout' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'checkouts a subversion with an explicit action' do
    expect(chef_run).to checkout_subversion('/tmp/explicit_action')
  end

  it 'checkouts a subversion with attributes' do
    expect(chef_run).to checkout_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
  end

  it 'checkouts a subversion when specifying the identity attribute' do
    expect(chef_run).to checkout_subversion('/tmp/identity_attribute')
  end
end

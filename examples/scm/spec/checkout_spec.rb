require 'chefspec'

describe 'scm::checkout' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'checkouts a scm with an explicit action' do
    expect(chef_run).to checkout_scm('/tmp/explicit_action')
  end

  it 'checkouts a scm with attributes' do
    expect(chef_run).to checkout_scm('/tmp/with_attributes').with(repository: 'ssh://scm.path')
  end

  it 'checkouts a scm when specifying the identity attribute' do
    expect(chef_run).to checkout_scm('/tmp/identity_attribute')
  end
end

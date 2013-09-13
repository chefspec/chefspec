require 'chefspec'

describe 'git::checkout' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'checkouts a git with an explicit action' do
    expect(chef_run).to checkout_git('/tmp/explicit_action')
  end

  it 'checkouts a git with attributes' do
    expect(chef_run).to checkout_git('/tmp/with_attributes').with(repository: 'ssh://git.path')
  end

  it 'checkouts a git when specifying the identity attribute' do
    expect(chef_run).to checkout_git('/tmp/identity_attribute')
  end
end

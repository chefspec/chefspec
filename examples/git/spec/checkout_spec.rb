require 'chefspec'

describe 'git::checkout' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'checkouts a git with an explicit action' do
    expect(chef_run).to checkout_git('/tmp/explicit_action')
    expect(chef_run).to_not checkout_git('/tmp/not_explicit_action')
  end

  it 'checkouts a git with attributes' do
    expect(chef_run).to checkout_git('/tmp/with_attributes').with(repository: 'ssh://git.path')
    expect(chef_run).to_not checkout_git('/tmp/with_attributes').with(repository: 'ssh://git.other_path')
  end

  it 'checkouts a git when specifying the identity attribute' do
    expect(chef_run).to checkout_git('/tmp/identity_attribute')
  end
end

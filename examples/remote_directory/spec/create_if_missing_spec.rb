require 'chefspec'

describe 'remote_directory::create_if_missing' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a remote_directory with an explicit action' do
    expect(chef_run).to create_remote_directory_if_missing('/tmp/explicit_action')
    expect(chef_run).to_not create_remote_directory_if_missing('/tmp/not_explicit_action')
  end

  it 'creates a remote_directory with attributes' do
    expect(chef_run).to create_remote_directory_if_missing('/tmp/with_attributes').with(owner: 'owner')
    expect(chef_run).to_not create_remote_directory_if_missing('/tmp/with_attributes').with(owner: 'bacon')
  end

  it 'creates a remote_directory when specifying the identity attribute' do
    expect(chef_run).to create_remote_directory_if_missing('/tmp/identity_attribute')
  end
end

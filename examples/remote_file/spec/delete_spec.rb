require 'chefspec'

describe 'remote_file::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a remote_file with an explicit action' do
    expect(chef_run).to delete_remote_file('/tmp/explicit_action')
  end

  it 'deletes a remote_file with attributes' do
    expect(chef_run).to delete_remote_file('/tmp/with_attributes').with(owner: 'owner')
  end

  it 'deletes a remote_file when specifying the identity attribute' do
    expect(chef_run).to delete_remote_file('/tmp/identity_attribute')
  end
end

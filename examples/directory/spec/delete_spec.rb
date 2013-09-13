require 'chefspec'

describe 'directory::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a directory with an explicit action' do
    expect(chef_run).to delete_directory('/tmp/explicit_action')
  end

  it 'deletes a directory with attributes' do
    expect(chef_run).to delete_directory('/tmp/with_attributes').with(
      user:   'user',
      group:  'group',
    )
  end

  it 'deletes a directory when specifying the identity attribute' do
    expect(chef_run).to delete_directory('/tmp/identity_attribute')
  end
end

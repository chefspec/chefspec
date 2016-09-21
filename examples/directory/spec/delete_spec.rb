require 'chefspec'

describe 'directory::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a directory with an explicit action' do
    expect(chef_run).to delete_directory('/tmp/explicit_action')
    expect(chef_run).to_not delete_directory('/tmp/not_explicit_action')
  end

  it 'deletes a directory with attributes' do
    expect(chef_run).to delete_directory('/tmp/with_attributes').with(
      user:   'user',
      group:  'group'
    )

    expect(chef_run).to_not delete_directory('/tmp/with_attributes').with(
      user:   'bacon',
      group:  'fat'
    )
  end

  it 'deletes a directory when specifying the identity attribute' do
    expect(chef_run).to delete_directory('/tmp/identity_attribute')
  end
end

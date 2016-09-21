require 'chefspec'

describe 'cookbook_file::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a cookbook_file with an explicit action' do
    expect(chef_run).to delete_cookbook_file('/tmp/explicit_action')
    expect(chef_run).to_not delete_cookbook_file('/tmp/not_explicit_action')
  end

  it 'deletes a cookbook_file with attributes' do
    expect(chef_run).to delete_cookbook_file('/tmp/with_attributes').with(backup: false)
    expect(chef_run).to_not delete_cookbook_file('/tmp/with_attributes').with(backup: true)
  end

  it 'deletes a cookbook_file when specifying the identity attribute' do
    expect(chef_run).to delete_cookbook_file('/tmp/identity_attribute')
  end
end

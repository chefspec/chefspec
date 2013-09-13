require 'chefspec'

describe 'cookbook_file::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a cookbook_file with an explicit action' do
    expect(chef_run).to delete_cookbook_file('/tmp/explicit_action')
  end

  it 'deletes a cookbook_file with attributes' do
    expect(chef_run).to delete_cookbook_file('/tmp/with_attributes').with(backup: false)
  end

  it 'deletes a cookbook_file when specifying the identity attribute' do
    expect(chef_run).to delete_cookbook_file('/tmp/identity_attribute')
  end
end

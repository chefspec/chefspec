require 'chefspec'

describe 'file::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a file with an explicit action' do
    expect(chef_run).to delete_file('/tmp/explicit_action')
  end

  it 'deletes a file with attributes' do
    expect(chef_run).to delete_file('/tmp/with_attributes').with(backup: false)
  end

  it 'deletes a file when specifying the identity attribute' do
    expect(chef_run).to delete_file('/tmp/identity_attribute')
  end
end

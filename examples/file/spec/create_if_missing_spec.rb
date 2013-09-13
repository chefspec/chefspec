require 'chefspec'

describe 'file::create_if_missing' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a file with an explicit action' do
    expect(chef_run).to create_file_if_missing('/tmp/explicit_action')
  end

  it 'creates a file with attributes' do
    expect(chef_run).to create_file_if_missing('/tmp/with_attributes').with(
      user:   'user',
      group:  'group',
      backup: false,
    )
  end

  it 'creates a file when specifying the identity attribute' do
    expect(chef_run).to create_file_if_missing('/tmp/identity_attribute')
  end
end

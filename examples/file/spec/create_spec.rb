require 'chefspec'

describe 'file::create' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a file with the default action' do
    expect(chef_run).to create_file('/tmp/default_action')
  end

  it 'creates a file with an explicit action' do
    expect(chef_run).to create_file('/tmp/explicit_action')
  end

  it 'creates a file with attributes' do
    expect(chef_run).to create_file('/tmp/with_attributes').with(
      user:   'user',
      group:  'group',
      backup: false,
    )
  end

  it 'creates a file when specifying the identity attribute' do
    expect(chef_run).to create_file('/tmp/identity_attribute')
  end
end

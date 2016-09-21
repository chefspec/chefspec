require 'chefspec'

describe 'cookbook_file::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a cookbook_file with the default action' do
    expect(chef_run).to create_cookbook_file('/tmp/default_action')
    expect(chef_run).to_not create_cookbook_file('/tmp/not_default_action')
  end

  it 'creates a cookbook_file with an explicit action' do
    expect(chef_run).to create_cookbook_file('/tmp/explicit_action')
  end

  it 'creates a cookbook_file with attributes' do
    expect(chef_run).to create_cookbook_file('/tmp/with_attributes').with(
      user:   'user',
      group:  'group',
      backup: false
    )

    expect(chef_run).to_not create_cookbook_file_if_missing('/tmp/with_attributes').with(
      user:   'bacon',
      group:  'fat',
      backup: true
    )
  end

  it 'creates a cookbook_file when specifying the identity attribute' do
    expect(chef_run).to create_cookbook_file('/tmp/identity_attribute')
  end
end

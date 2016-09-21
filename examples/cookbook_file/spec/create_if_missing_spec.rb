require 'chefspec'

describe 'cookbook_file::create_if_missing' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a cookbook_file with an explicit action' do
    expect(chef_run).to create_cookbook_file_if_missing('/tmp/explicit_action')
    expect(chef_run).to_not create_cookbook_file_if_missing('/tmp/not_explicit_action')
  end

  it 'creates a cookbook_file with attributes' do
    expect(chef_run).to create_cookbook_file_if_missing('/tmp/with_attributes').with(
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
    expect(chef_run).to create_cookbook_file_if_missing('/tmp/identity_attribute')
  end
end

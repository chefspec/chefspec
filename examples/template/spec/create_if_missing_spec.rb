require 'chefspec'

describe 'template::create_if_missing' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a template with an explicit action' do
    expect(chef_run).to create_template_if_missing('/tmp/explicit_action')
    expect(chef_run).to_not create_template_if_missing('/tmp/not_explicit_action')
  end

  it 'creates a template with attributes' do
    expect(chef_run).to create_template_if_missing('/tmp/with_attributes').with(
      user:   'user',
      group:  'group',
      backup: false
    )

    expect(chef_run).to_not create_template_if_missing('/tmp/with_attributes').with(
      user:   'bacon',
      group:  'fat',
      backup: true
    )
  end

  it 'creates a template when specifying the identity attribute' do
    expect(chef_run).to create_template_if_missing('/tmp/identity_attribute')
  end
end

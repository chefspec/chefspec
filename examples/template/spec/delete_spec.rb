require 'chefspec'

describe 'template::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a template with an explicit action' do
    expect(chef_run).to delete_template('/tmp/explicit_action')
    expect(chef_run).to_not delete_template('/tmp/not_explicit_action')
  end

  it 'deletes a template with attributes' do
    expect(chef_run).to delete_template('/tmp/with_attributes').with(backup: false)
    expect(chef_run).to_not delete_template('/tmp/with_attributes').with(backup: true)
  end

  it 'deletes a template when specifying the identity attribute' do
    expect(chef_run).to delete_template('/tmp/identity_attribute')
  end
end

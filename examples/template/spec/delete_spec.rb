require 'chefspec'

describe 'template::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a template with an explicit action' do
    expect(chef_run).to delete_template('/tmp/explicit_action')
  end

  it 'deletes a template with attributes' do
    expect(chef_run).to delete_template('/tmp/with_attributes').with(backup: false)
  end

  it 'deletes a template when specifying the identity attribute' do
    expect(chef_run).to delete_template('/tmp/identity_attribute')
  end
end

require 'chefspec'

describe 'template::touch' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'touches a template with an explicit action' do
    expect(chef_run).to touch_template('/tmp/explicit_action')
  end

  it 'touches a template with attributes' do
    expect(chef_run).to touch_template('/tmp/with_attributes').with(backup: false)
  end

  it 'touches a template when specifying the identity attribute' do
    expect(chef_run).to touch_template('/tmp/identity_attribute')
  end
end

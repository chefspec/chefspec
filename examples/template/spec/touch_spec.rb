require 'chefspec'

describe 'template::touch' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'touches a template with an explicit action' do
    expect(chef_run).to touch_template('/tmp/explicit_action')
    expect(chef_run).to_not touch_template('/tmp/not_explicit_action')
  end

  it 'touches a template with attributes' do
    expect(chef_run).to touch_template('/tmp/with_attributes').with(backup: false)
    expect(chef_run).to_not touch_template('/tmp/with_attributes').with(backup: true)
  end

  it 'touches a template when specifying the identity attribute' do
    expect(chef_run).to touch_template('/tmp/identity_attribute')
  end
end

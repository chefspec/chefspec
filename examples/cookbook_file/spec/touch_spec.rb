require 'chefspec'

describe 'cookbook_file::touch' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'touches a cookbook_file with an explicit action' do
    expect(chef_run).to touch_cookbook_file('/tmp/explicit_action')
  end

  it 'touches a cookbook_file with attributes' do
    expect(chef_run).to touch_cookbook_file('/tmp/with_attributes').with(backup: false)
  end

  it 'touches a cookbook_file when specifying the identity attribute' do
    expect(chef_run).to touch_cookbook_file('/tmp/identity_attribute')
  end
end

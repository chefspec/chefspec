require 'chefspec'

describe 'file::touch' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'touches a file with an explicit action' do
    expect(chef_run).to touch_file('/tmp/explicit_action')
  end

  it 'touches a file with attributes' do
    expect(chef_run).to touch_file('/tmp/with_attributes').with(backup: false)
  end

  it 'touches a file when specifying the identity attribute' do
    expect(chef_run).to touch_file('/tmp/identity_attribute')
  end
end

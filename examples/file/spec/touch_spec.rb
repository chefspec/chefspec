require 'chefspec'

describe 'file::touch' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'touches a file with an explicit action' do
    expect(chef_run).to touch_file('/tmp/explicit_action')
    expect(chef_run).to_not touch_file('/tmp/not_explicit_action')
  end

  it 'touches a file with attributes' do
    expect(chef_run).to touch_file('/tmp/with_attributes').with(backup: false)
    expect(chef_run).to_not touch_file('/tmp/with_attributes').with(backup: true)
  end

  it 'touches a file when specifying the identity attribute' do
    expect(chef_run).to touch_file('/tmp/identity_attribute')
  end
end

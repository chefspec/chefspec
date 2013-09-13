require 'chefspec'

describe 'remote_file::touch' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'touchs a remote_file with an explicit action' do
    expect(chef_run).to touch_remote_file('/tmp/explicit_action')
  end

  it 'touchs a remote_file with attributes' do
    expect(chef_run).to touch_remote_file('/tmp/with_attributes').with(owner: 'owner')
  end

  it 'touchs a remote_file when specifying the identity attribute' do
    expect(chef_run).to touch_remote_file('/tmp/identity_attribute')
  end
end

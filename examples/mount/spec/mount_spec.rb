require 'chefspec'

describe 'mount::mount' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'mounts a mount with the default action' do
    expect(chef_run).to mount_mount('/tmp/default_action')
  end

  it 'mounts a mount with an explicit action' do
    expect(chef_run).to mount_mount('/tmp/explicit_action')
  end

  it 'mounts a mount with attributes' do
    expect(chef_run).to mount_mount('/tmp/with_attributes').with(dump: 3)
  end
end

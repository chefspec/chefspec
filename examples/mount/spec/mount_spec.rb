require 'chefspec'

describe 'mount::mount' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'mounts a mount with the default action' do
    expect(chef_run).to mount_mount('/tmp/default_action')
    expect(chef_run).to_not mount_mount('/tmp/not_default_action')
  end

  it 'mounts a mount with an explicit action' do
    expect(chef_run).to mount_mount('/tmp/explicit_action')
  end

  it 'mounts a mount with attributes' do
    expect(chef_run).to mount_mount('/tmp/with_attributes').with(dump: 3)
    expect(chef_run).to_not mount_mount('/tmp/with_attributes').with(dump: 5)
  end
end

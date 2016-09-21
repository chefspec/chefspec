require 'chefspec'

describe 'mount::umount' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'umounts a mount with an explicit action' do
    expect(chef_run).to umount_mount('/tmp/explicit_action')
    expect(chef_run).to_not umount_mount('/tmp/not_explicit_action')
  end

  it 'umounts a mount with attributes' do
    expect(chef_run).to umount_mount('/tmp/with_attributes').with(dump: 3)
    expect(chef_run).to_not umount_mount('/tmp/with_attributes').with(dump: 5)
  end
end

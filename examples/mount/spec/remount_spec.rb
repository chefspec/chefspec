require 'chefspec'

describe 'mount::remount' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'remounts a mount with an explicit action' do
    expect(chef_run).to remount_mount('/tmp/explicit_action')
    expect(chef_run).to_not remount_mount('/tmp/not_explicit_action')
  end

  it 'remounts a mount with attributes' do
    expect(chef_run).to remount_mount('/tmp/with_attributes').with(dump: 3)
    expect(chef_run).to_not remount_mount('/tmp/with_attributes').with(dump: 5)
  end
end

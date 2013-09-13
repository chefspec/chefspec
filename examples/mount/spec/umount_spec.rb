require 'chefspec'

describe 'mount::umount' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'umounts a mount with an explicit action' do
    expect(chef_run).to umount_mount('/tmp/explicit_action')
  end

  it 'umounts a mount with attributes' do
    expect(chef_run).to umount_mount('/tmp/with_attributes').with(dump: 3)
  end
end

require 'chefspec'

describe 'mount::remount' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'remounts a mount with an explicit action' do
    expect(chef_run).to remount_mount('/tmp/explicit_action')
  end

  it 'remounts a mount with attributes' do
    expect(chef_run).to remount_mount('/tmp/with_attributes').with(dump: 3)
  end
end

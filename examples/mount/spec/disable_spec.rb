require 'chefspec'

describe 'mount::disable' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'disables a mount with an explicit action' do
    expect(chef_run).to disable_mount('/tmp/explicit_action')
  end

  it 'disables a mount with attributes' do
    expect(chef_run).to disable_mount('/tmp/with_attributes').with(dump: 3)
  end
end

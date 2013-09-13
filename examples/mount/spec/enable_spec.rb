require 'chefspec'

describe 'mount::enable' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'enables a mount with an explicit action' do
    expect(chef_run).to enable_mount('/tmp/explicit_action')
  end

  it 'enables a mount with attributes' do
    expect(chef_run).to enable_mount('/tmp/with_attributes').with(dump: 3)
  end
end

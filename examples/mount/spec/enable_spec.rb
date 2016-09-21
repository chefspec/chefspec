require 'chefspec'

describe 'mount::enable' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'enables a mount with an explicit action' do
    expect(chef_run).to enable_mount('/tmp/explicit_action')
    expect(chef_run).to_not enable_mount('/tmp/not_explicit_action')
  end

  it 'enables a mount with attributes' do
    expect(chef_run).to enable_mount('/tmp/with_attributes').with(dump: 3)
    expect(chef_run).to_not enable_mount('/tmp/with_attributes').with(dump: 5)
  end
end

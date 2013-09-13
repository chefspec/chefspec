require 'chefspec'

describe 'ifconfig::enable' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'enables a ifconfig with an explicit action' do
    expect(chef_run).to enable_ifconfig('10.0.0.2')
  end

  it 'enables a ifconfig with attributes' do
    expect(chef_run).to enable_ifconfig('10.0.0.3').with(device: 'en0')
  end
end

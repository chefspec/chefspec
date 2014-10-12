require 'chefspec'

describe 'ifconfig::enable' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'enables a ifconfig with an explicit action' do
    expect(chef_run).to enable_ifconfig('10.0.0.2')
    expect(chef_run).to_not enable_ifconfig('10.0.0.10')
  end

  it 'enables a ifconfig with attributes' do
    expect(chef_run).to enable_ifconfig('10.0.0.3').with(device: 'en0')
    expect(chef_run).to_not enable_ifconfig('10.0.0.3').with(device: 'en1')
  end
end

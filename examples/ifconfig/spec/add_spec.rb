require 'chefspec'

describe 'ifconfig::add' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'adds a ifconfig with the default action' do
    expect(chef_run).to add_ifconfig('10.0.0.1')
    expect(chef_run).to_not add_ifconfig('10.0.0.10')
  end

  it 'adds a ifconfig with an explicit action' do
    expect(chef_run).to add_ifconfig('10.0.0.2')
  end

  it 'adds a ifconfig with attributes' do
    expect(chef_run).to add_ifconfig('10.0.0.3').with(device: 'en0')
    expect(chef_run).to_not add_ifconfig('10.0.0.3').with(device: 'en1')
  end
end

require 'chefspec'

describe 'route::add' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'adds a route with the default action' do
    expect(chef_run).to add_route('10.0.0.1')
    expect(chef_run).to_not add_route('10.0.0.10')
  end

  it 'adds a route with an explicit action' do
    expect(chef_run).to add_route('10.0.0.2')
  end

  it 'adds a route with attributes' do
    expect(chef_run).to add_route('10.0.0.3').with(gateway: '10.0.0.0')
    expect(chef_run).to_not add_route('10.0.0.3').with(gateway: '10.0.0.100')
  end

  it 'adds a route when specifying the identity attribute' do
    expect(chef_run).to add_route('10.0.0.4')
  end
end

require 'chefspec'

describe 'route::add' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'adds a route with the default action' do
    expect(chef_run).to add_route('10.0.0.1')
  end

  it 'adds a route with an explicit action' do
    expect(chef_run).to add_route('10.0.0.2')
  end

  it 'adds a route with attributes' do
    expect(chef_run).to add_route('10.0.0.3').with(gateway: '10.0.0.0')
  end

  it 'adds a route when specifying the identity attribute' do
    expect(chef_run).to add_route('10.0.0.4')
  end
end

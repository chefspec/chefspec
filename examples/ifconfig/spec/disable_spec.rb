require 'chefspec'

describe 'ifconfig::disable' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'disables a ifconfig with an explicit action' do
    expect(chef_run).to disable_ifconfig('10.0.0.2')
  end

  it 'disables a ifconfig with attributes' do
    expect(chef_run).to disable_ifconfig('10.0.0.3').with(device: 'en0')
  end
end

require 'chefspec'

describe 'ifconfig::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a ifconfig with an explicit action' do
    expect(chef_run).to delete_ifconfig('10.0.0.2')
  end

  it 'deletes a ifconfig with attributes' do
    expect(chef_run).to delete_ifconfig('10.0.0.3').with(device: 'en0')
  end
end

require 'chefspec'

describe 'ifconfig::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a ifconfig with an explicit action' do
    expect(chef_run).to delete_ifconfig('10.0.0.2')
    expect(chef_run).to_not delete_ifconfig('10.0.0.10')
  end

  it 'deletes a ifconfig with attributes' do
    expect(chef_run).to delete_ifconfig('10.0.0.3').with(device: 'en0')
    expect(chef_run).to_not delete_ifconfig('10.0.0.3').with(device: 'en1')
  end
end

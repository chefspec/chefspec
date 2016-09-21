require 'chefspec'

describe 'attributes::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |node|
      node.automatic['ipaddress'] = '500.500.500.500' # Intentionally not a real IP
      node.normal['attributes']['message'] = 'The new message is here'
    end.converge(described_recipe)
  end

  it 'uses the overridden node attribute' do
    expect(chef_run).to write_log('The new message is here')
    expect(chef_run).to_not write_log('This is the default message')
  end

  it 'uses the overridden ohai attribute' do
    expect(chef_run).to write_log('500.500.500.500')
    expect(chef_run).to_not write_log('127.0.0.1')
  end
end

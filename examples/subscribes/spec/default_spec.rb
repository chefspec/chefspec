require 'chefspec'

describe 'subscribes::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:service)  { chef_run.service('receiving_resource') }

  it 'subscribes to the template creation' do
    expect(service).to subscribe_to('template[/tmp/notifying_resource]')
    expect(service).to_not subscribe_to('template[not_receiving_resource]')
  end

  it 'subscribes to the specific action on the resource' do
    expect(service).to subscribe_to('template[/tmp/notifying_resource]').on(:create)
    expect(service).to_not subscribe_to('template[/tmp/notifying_resource]').on(:delete)
  end
end

require 'chefspec'

describe 'subscribes::immediately' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:service) { chef_run.service('receiving_resource') }

  it 'sends a notification to the service' do
    expect(service).to subscribe_to('template[/tmp/notifying_resource]').immediately
    expect(service).to_not subscribe_to('template[/tmp/not_notifying_resource]').immediately
  end

  it 'sends the specific notification to the serivce immediately' do
    expect(service).to subscribe_to('template[/tmp/notifying_resource]').on(:create).immediately
    expect(service).to_not subscribe_to('template[/tmp/notifying_resource]').on(:delete).delayed
  end
end

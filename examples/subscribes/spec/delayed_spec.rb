require 'chefspec'

describe 'subscribes::delayed' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
  let(:service) { chef_run.service('receiving_resource') }

  it 'subscribes to the template creation' do
    expect(service).to subscribe_to('template[/tmp/notifying_resource]').delayed
    expect(service).to_not subscribe_to('template[/tmp/not_notifying_resource]').delayed
  end

  it 'subscribes to the specific action on the resource delayed' do
    expect(service).to subscribe_to('template[/tmp/notifying_resource]').on(:create).delayed
    expect(service).to_not subscribe_to('template[/tmp/notifying_resource]').on(:delete).immediately
  end
end

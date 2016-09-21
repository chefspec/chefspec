require 'chefspec'

describe 'subscribes::chained' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:service)  { chef_run.service('service') }
  let(:log)      { chef_run.log('log') }

  it 'subscribes to the template creation' do
    expect(service).to subscribe_to('template[template]')
    expect(service).to_not subscribe_to('template[not_template]')
  end

  it 'subscribes to a subscription from the first' do
    expect(log).to subscribe_to('service[service]')
  end

  it 'subscribes to the specific subscription' do
    expect(service).to subscribe_to('template[template]').on(:create)
    expect(service).to_not subscribe_to('template[template]').on(:delete)
  end
end

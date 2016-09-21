require 'chefspec'

describe 'notifications::chained' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:template) { chef_run.template('template') }
  let(:service)  { chef_run.service('service') }

  it 'sends a notification to the first service' do
    expect(template).to notify('service[service]')
    expect(template).to_not notify('service[not_service]')
  end

  it 'sends a notification to the second service through the first' do
    expect(service).to notify('log[log]')
  end

  it 'sends the specific notification to the serivce' do
    expect(template).to notify('service[service]').to(:restart)
    expect(template).to_not notify('service[service]').to(:stop)
  end
end

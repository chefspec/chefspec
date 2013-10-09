require 'chefspec'

describe 'notifications::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:template) { chef_run.template('/tmp/notifying_resource') }

  it 'sends a notification to the service' do
    expect(template).to notify('service[receiving_resource]')
    expect(template).to_not notify('service[not_receiving_resource]')
  end

  it 'sends the specific notification to the serivce' do
    expect(template).to notify('service[receiving_resource]').to(:restart)
    expect(template).to_not notify('service[receiving_resource]').to(:stop)
  end
end

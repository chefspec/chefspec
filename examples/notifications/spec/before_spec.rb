require 'chefspec'

describe 'notifications::before' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:template) { chef_run.template('/tmp/notifying_resource') }

  it 'sends a notification to the service' do
    expect(template).to notify('service[receiving_resource]').before
    expect(template).to_not notify('service[not_receiving_resource]').before
  end

  it 'sends the specific notification to the service before' do
    expect(template).to notify('service[receiving_resource]').to(:restart).before
    expect(template).to_not notify('service[receiving_resource]').to(:restart).immediately
  end
end

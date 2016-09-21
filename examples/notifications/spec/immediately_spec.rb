require 'chefspec'

describe 'notifications::immediately' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:template) { chef_run.template('/tmp/notifying_resource') }

  it 'sends a notification to the service' do
    expect(template).to notify('service[receiving_resource]').immediately
    expect(template).to_not notify('service[not_receiving_resource]').immediately
  end

  it 'sends the specific notification to the serivce immediately' do
    expect(template).to notify('service[receiving_resource]').to(:restart).immediately
    expect(template).to_not notify('service[receiving_resource]').to(:restart).delayed
  end
end

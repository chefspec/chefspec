require 'chefspec'

describe 'notifications::delayed' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:template) { chef_run.template('/tmp/notifying_resource') }

  it 'sends a notification to the service' do
    expect(template).to notify('service[receiving_resource]').delayed
  end

  it 'sends the specific notification to the serivce delayed' do
    expect(template).to notify('service[receiving_resource]').to(:restart).delayed
  end
end

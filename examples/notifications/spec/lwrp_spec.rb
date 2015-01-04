require 'chefspec'

describe 'notifications::lwrp' do
  let(:chef_run) { ChefSpec::ServerRunner.new(step_into: ['default']).converge(described_recipe) }

  it 'sends a notification to the service[test] when resource was updated by last action' do
    notifying_resource = chef_run.notifications('update')
    expect(notifying_resource).to notify('service[test]')
  end

  it 'sends a specific notification to the service[test] when resource was updated by last action' do
    notifying_resource = chef_run.notifications('update')
    expect(notifying_resource).to notify('service[test]').to(:restart)
  end

  it 'does not send a notification to the service[test] when resource was not updated by last action' do
    notifying_resource = chef_run.notifications('nothing')
    expect(notifying_resource).to_not notify('service[test]')
  end

  it 'does not send a specific notification to the service[test] when resource was not updated by last action' do
    notifying_resource = chef_run.notifications('nothing')
    expect(notifying_resource).to_not notify('service[test]').to(:restart)
  end

end

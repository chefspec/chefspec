require 'chefspec'

describe 'notifications::guard' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'using not_if' do
    it 'does not send a notification to the service when guard condition true' do
      template = chef_run.template('/tmp/notifying_resource_with_not_if_true')
      expect(template).to_not notify('service[receiving_resource]')
    end

    it 'sends a notification to the service when guard condition false' do
      template = chef_run.template('/tmp/notifying_resource_with_not_if_false')
      expect(template).to notify('service[receiving_resource]')
    end
  end

  context 'using only_if' do
    it 'sends a notification to the service when guard condition true' do
      template = chef_run.template('/tmp/notifying_resource_with_only_if_true')
      expect(template).to notify('service[receiving_resource]')
    end

    it 'does not send a notification to the service when guard condition false' do
      template = chef_run.template('/tmp/notifying_resource_with_only_if_false')
      expect(template).to_not notify('service[receiving_resource]')
    end
  end
end

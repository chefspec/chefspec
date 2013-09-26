require 'chefspec'

describe 'mdadm::stop' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'stops a mdadm with an explicit action' do
    expect(chef_run).to stop_mdadm('explicit_action')
  end

  it 'stops a mdadm with attributes' do
    expect(chef_run).to stop_mdadm('with_attributes').with(chunk: 8)
  end

  it 'stops a mdadm when specifying the identity attribute' do
    expect(chef_run).to stop_mdadm('identity_attribute')
  end
end

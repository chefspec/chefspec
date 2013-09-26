require 'chefspec'

describe 'batch::run' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'runs a batch with the default action' do
    expect(chef_run).to run_batch('default_action')
  end

  it 'runs a batch with an explicit action' do
    expect(chef_run).to run_batch('explicit_action')
  end

  it 'runs a batch with attributes' do
    expect(chef_run).to run_batch('with_attributes').with(flags: '-f')
  end

  it 'runs a batch when specifying the identity attribute' do
    expect(chef_run).to run_batch('identity_attribute')
  end
end

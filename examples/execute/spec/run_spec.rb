require 'chefspec'

describe 'execute::run' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'runs a execute with the default action' do
    expect(chef_run).to run_execute('default_action')
  end

  it 'runs a execute with an explicit action' do
    expect(chef_run).to run_execute('explicit_action')
  end

  it 'runs a execute with attributes' do
    expect(chef_run).to run_execute('with_attributes').with(user: 'user')
  end

  it 'runs a execute when specifying the identity attribute' do
    expect(chef_run).to run_execute('identity_attribute')
  end
end

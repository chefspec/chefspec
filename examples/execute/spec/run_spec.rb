require 'chefspec'

describe 'execute::run' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'runs a execute with the default action' do
    expect(chef_run).to run_execute('default_action')
    expect(chef_run).to_not run_execute('not_default_action')
  end

  it 'runs a execute with an explicit action' do
    expect(chef_run).to run_execute('explicit_action')
  end

  it 'runs a execute with attributes' do
    expect(chef_run).to run_execute('with_attributes').with(user: 'user')
    expect(chef_run).to_not run_execute('with_attributes').with(user: 'not_user')
  end

  it 'runs a execute when specifying the identity attribute' do
    expect(chef_run).to run_execute('identity_attribute')
  end
end

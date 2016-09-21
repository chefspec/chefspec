require 'chefspec'

describe 'erl_call::run' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'runs a erl_call with the default action' do
    expect(chef_run).to run_erl_call('default_action')
    expect(chef_run).to_not run_erl_call('not_default_action')
  end

  it 'runs a erl_call with an explicit action' do
    expect(chef_run).to run_erl_call('explicit_action')
  end

  it 'runs a erl_call with attributes' do
    expect(chef_run).to run_erl_call('with_attributes').with(code: 'hello')
    expect(chef_run).to_not run_erl_call('with_attributes').with(code: 'not_hello')
  end

  it 'runs a erl_call when specifying the identity attribute' do
    expect(chef_run).to run_erl_call('identity_attribute')
  end
end

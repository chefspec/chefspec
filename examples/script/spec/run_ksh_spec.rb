require 'chefspec'

describe 'script::run_ksh' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'runs a ksh script with the default action' do
    expect(chef_run).to run_ksh('default_action')
    expect(chef_run).to_not run_ksh('not_default_action')
  end

  it 'runs a ksh script with an explicit action' do
    expect(chef_run).to run_ksh('explicit_action')
  end

  it 'runs a ksh script with attributes' do
    expect(chef_run).to run_ksh('with_attributes').with(creates: 'creates')
    expect(chef_run).to_not run_ksh('with_attributes').with(creates: 'bacon')
  end

  it 'runs a ksh script when specifying the identity attribute' do
    expect(chef_run).to run_ksh('identity_attribute')
  end
end

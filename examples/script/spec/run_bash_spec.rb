require 'chefspec'

describe 'script::run_bash' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'runs a bash script with the default action' do
    expect(chef_run).to run_bash('default_action')
    expect(chef_run).to_not run_bash('not_default_action')
  end

  it 'runs a bash script with an explicit action' do
    expect(chef_run).to run_bash('explicit_action')
  end

  it 'runs a bash script with attributes' do
    expect(chef_run).to run_bash('with_attributes').with(creates: 'creates')
    expect(chef_run).to_not run_bash('with_attributes').with(creates: 'bacon')
  end
end

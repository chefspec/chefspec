require 'chefspec'

describe 'powershell_script::run' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'runs a powershell_script with the default action' do
    expect(chef_run).to run_powershell_script('default_action')
  end

  it 'runs a powershell_script with an explicit action' do
    expect(chef_run).to run_powershell_script('explicit_action')
  end

  it 'runs a powershell_script with attributes' do
    expect(chef_run).to run_powershell_script('with_attributes').with(flags: '--flags')
  end

  it 'runs a powershell_script when specifying the identity attribute' do
    expect(chef_run).to run_powershell_script('identity_attribute')
  end
end

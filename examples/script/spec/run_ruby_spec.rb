require 'chefspec'

describe 'script::run_ruby' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'runs a ruby script with the default action' do
    expect(chef_run).to run_ruby('default_action')
  end

  it 'runs a ruby script with an explicit action' do
    expect(chef_run).to run_ruby('explicit_action')
  end

  it 'runs a ruby script with attributes' do
    expect(chef_run).to run_ruby('with_attributes').with(creates: 'creates')
  end

  it 'runs a ruby script when specifying the identity attribute' do
    expect(chef_run).to run_ruby('identity_attribute')
  end
end

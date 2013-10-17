require 'chefspec'

describe 'multiple_actions::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'executes both actions' do
    expect(chef_run).to enable_service('resource')
    expect(chef_run).to start_service('resource')
  end

  it 'does not match other actions' do
    expect(chef_run).to_not disable_service('resource')
  end
end

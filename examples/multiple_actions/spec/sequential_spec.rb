require 'chefspec'

describe 'multiple_actions::sequential' do
  let(:chef_run) { ChefSpec::Runner.new(log_level: :fatal).converge(described_recipe) }

  it 'executes both actions' do
    expect(chef_run).to start_service('resource')
  end

  it 'does not match other actions' do
    expect(chef_run).to_not disable_service('resource')
  end
end

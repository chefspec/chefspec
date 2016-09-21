require 'chefspec'

describe 'multiple_actions::sequential' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', log_level: :fatal)
                          .converge(described_recipe)
  end

  it 'executes both actions' do
    expect(chef_run).to start_service('resource')
  end

  it 'does not match other actions' do
    expect(chef_run).to_not disable_service('resource')
  end
end

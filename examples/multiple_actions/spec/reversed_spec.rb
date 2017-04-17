require 'chefspec'

describe 'multiple_actions::reversed' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', log_level: :fatal)
                          .converge(described_recipe)
  end

  it 'executes both actions' do
    expect(chef_run).to stop_service('foo').with(stop_command: 'bar')
    expect(chef_run).to start_service('foo').with(start_command: 'baz')
  end

  it 'does not match other actions' do
    expect(chef_run).to_not disable_service('foo')
  end
end

require 'chefspec'

describe 'server::environment' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node, server|
      server.create_environment('production')
    end.converge(described_recipe)
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for environments' do
    expect(chef_run).to write_log('environments')
      .with_message('_default, production')
  end
end

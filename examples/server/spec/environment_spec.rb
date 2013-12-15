require 'chefspec'
load 'chefspec/server.rb'

describe 'server::environment' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for environments' do
    ChefSpec::Server.create_environment('production')

    expect(chef_run).to write_log('environments')
      .with_message('_default, production')
  end
end

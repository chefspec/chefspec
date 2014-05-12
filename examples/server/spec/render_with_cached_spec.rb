require 'chefspec'
require 'chefspec/cacher'
load 'chefspec/server.rb'

RSpec.configure do |config|
  config.extend(ChefSpec::Cacher)
end

describe 'server::render_with_cached' do
  cached(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does not cache file requests' do
    expect(chef_run).to render_file('/tmp/file')
    expect(chef_run).to render_file('/tmp/file').with_content('This is content!')
  end
end

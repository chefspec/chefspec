require 'chefspec'

describe 'link::link_to' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a link to the specified target' do
    link = chef_run.link('/tmp/path')
    expect(link).to link_to('destination')
    expect(link).to_not link_to('other_destination')
  end
end

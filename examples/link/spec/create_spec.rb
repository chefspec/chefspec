require 'chefspec'

describe 'link::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a link with the default action' do
    expect(chef_run).to create_link('/tmp/default_action')
    expect(chef_run).to_not create_link('/tmp/not_default_action')
  end

  it 'creates a link with an explicit action' do
    expect(chef_run).to create_link('/tmp/explicit_action')
  end

  it 'creates a link with attributes' do
    expect(chef_run).to create_link('/tmp/with_attributes').with(to: 'destination')
    expect(chef_run).to_not create_link('/tmp/with_attributes').with(to: 'other_destination')
  end

  it 'creates a link when specifying the identity attribute' do
    expect(chef_run).to create_link('/tmp/identity_attribute')
  end
end

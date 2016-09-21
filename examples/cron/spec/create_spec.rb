require 'chefspec'

describe 'cron::create' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'creates a cron with the default action' do
    expect(chef_run).to create_cron('default_action')
    expect(chef_run).to_not create_cron('not_default_action')
  end

  it 'creates a cron with an explicit action' do
    expect(chef_run).to create_cron('explicit_action')
  end

  it 'creates a cron with attributes' do
    expect(chef_run).to create_cron('with_attributes').with(minute: '0', hour: '20')
    expect(chef_run).to_not create_cron('with_attributes').with(minute: '10', hour: '30')
  end
end

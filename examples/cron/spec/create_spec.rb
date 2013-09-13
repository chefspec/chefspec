require 'chefspec'

describe 'cron::create' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a cron with the default action' do
    expect(chef_run).to create_cron('default_action')
  end

  it 'creates a cron with an explicit action' do
    expect(chef_run).to create_cron('explicit_action')
  end

  it 'creates a cron with attributes' do
    expect(chef_run).to create_cron('with_attributes').with(minute: '0', hour: '20')
  end
end

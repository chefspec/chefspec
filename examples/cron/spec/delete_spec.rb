require 'chefspec'

describe 'cron::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a cron with an explicit action' do
    expect(chef_run).to delete_cron('explicit_action')
    expect(chef_run).to_not delete_cron('not_explicit_action')
  end

  it 'deletes a cron with attributes' do
    expect(chef_run).to delete_cron('with_attributes').with(minute: '0', hour: '20')
    expect(chef_run).to_not delete_cron('with_attributes').with(minute: '10', hour: '30')
  end
end

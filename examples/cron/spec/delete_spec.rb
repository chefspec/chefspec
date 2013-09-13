require 'chefspec'

describe 'cron::delete' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'deletes a cron with an explicit action' do
    expect(chef_run).to delete_cron('explicit_action')
  end

  it 'deletes a cron with attributes' do
    expect(chef_run).to delete_cron('with_attributes').with(minute: '0', hour: '20')
  end
end

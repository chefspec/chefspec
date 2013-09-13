require 'chefspec'

describe 'user::unlock' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'unlocks a user with an explicit action' do
    expect(chef_run).to unlock_user('explicit_action')
  end

  it 'unlocks a user with attributes' do
    expect(chef_run).to unlock_user('with_attributes').with(uid: '1234')
  end

  it 'unlocks a user when specifying the identity attribute' do
    expect(chef_run).to unlock_user('identity_attribute')
  end
end

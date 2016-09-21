require 'chefspec'

describe 'user::unlock' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'unlocks a user with an explicit action' do
    expect(chef_run).to unlock_user('explicit_action')
    expect(chef_run).to_not unlock_user('not_explicit_action')
  end

  it 'unlocks a user with attributes' do
    expect(chef_run).to unlock_user('with_attributes').with(uid: '1234')
    expect(chef_run).to_not unlock_user('with_attributes').with(uid: '5678')
  end

  it 'unlocks a user when specifying the identity attribute' do
    expect(chef_run).to unlock_user('identity_attribute')
  end
end

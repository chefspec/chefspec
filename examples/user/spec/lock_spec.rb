require 'chefspec'

describe 'user::lock' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(described_recipe) }

  it 'locks a user with an explicit action' do
    expect(chef_run).to lock_user('explicit_action')
    expect(chef_run).to_not lock_user('not_explicit_action')
  end

  it 'locks a user with attributes' do
    expect(chef_run).to lock_user('with_attributes').with(uid: '1234')
    expect(chef_run).to_not lock_user('with_attributes').with(uid: '5678')
  end

  it 'locks a user when specifying the identity attribute' do
    expect(chef_run).to lock_user('identity_attribute')
  end
end

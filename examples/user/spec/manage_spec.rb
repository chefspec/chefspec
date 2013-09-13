require 'chefspec'

describe 'user::manage' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'manages a user with an explicit action' do
    expect(chef_run).to manage_user('explicit_action')
  end

  it 'manages a user with attributes' do
    expect(chef_run).to manage_user('with_attributes').with(uid: '1234')
  end

  it 'manages a user when specifying the identity attribute' do
    expect(chef_run).to manage_user('identity_attribute')
  end
end

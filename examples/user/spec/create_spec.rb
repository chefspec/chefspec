require 'chefspec'

describe 'user::create' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'creates a user with the default action' do
    expect(chef_run).to create_user('default_action')
  end

  it 'creates a user with an explicit action' do
    expect(chef_run).to create_user('explicit_action')
  end

  it 'creates a user with attributes' do
    expect(chef_run).to create_user('with_attributes').with(uid: '1234')
  end

  it 'creates a user when specifying the identity attribute' do
    expect(chef_run).to create_user('identity_attribute')
  end
end

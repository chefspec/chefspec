require 'chefspec'

describe 'user::create' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'creates a user with the default action' do
    expect(chef_run).to create_user('default_action')
    expect(chef_run).to_not create_user('not_default_action')
  end

  it 'creates a user with an explicit action' do
    expect(chef_run).to create_user('explicit_action')
  end

  it 'creates a user with attributes' do
    expect(chef_run).to create_user('with_attributes').with(uid: '1234')
    expect(chef_run).to_not create_user('with_attributes').with(uid: '5678')
  end

  it 'creates a user when specifying the identity attribute' do
    expect(chef_run).to create_user('identity_attribute')
  end
end

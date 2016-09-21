require 'chefspec'

describe 'user::manage' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'manages a user with an explicit action' do
    expect(chef_run).to manage_user('explicit_action')
    expect(chef_run).to_not manage_user('not_explicit_action')
  end

  it 'manages a user with attributes' do
    expect(chef_run).to manage_user('with_attributes').with(uid: '1234')
    expect(chef_run).to_not manage_user('with_attributes').with(uid: '5678')
  end

  it 'manages a user when specifying the identity attribute' do
    expect(chef_run).to manage_user('identity_attribute')
  end
end

require 'chefspec'

describe 'user::lock' do
  platform 'ubuntu'

  describe 'locks a user with an explicit action' do
    it { is_expected.to lock_user('explicit_action') }
    it { is_expected.to_not lock_user('not_explicit_action') }
  end

  describe 'locks a user with attributes' do
    it { is_expected.to lock_user('with_attributes').with(uid: '1234') }
    it { is_expected.to_not lock_user('with_attributes').with(uid: '5678') }
  end

  describe 'locks a user when specifying the identity attribute' do
    it { is_expected.to lock_user('identity_attribute') }
  end
end

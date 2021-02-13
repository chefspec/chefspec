require 'chefspec'

describe 'user::unlock' do
  platform 'ubuntu'

  describe 'unlocks a user with an explicit action' do
    it { is_expected.to unlock_user('explicit_action') }
    it { is_expected.to_not unlock_user('not_explicit_action') }
  end

  describe 'unlocks a user with attributes' do
    it { is_expected.to unlock_user('with_attributes').with(uid: '1234') }
    it { is_expected.to_not unlock_user('with_attributes').with(uid: '5678') }
  end

  describe 'unlocks a user when specifying the identity attribute' do
    it { is_expected.to unlock_user('identity_attribute') }
  end
end

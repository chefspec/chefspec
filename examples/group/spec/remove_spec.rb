require 'chefspec'

describe 'group::remove' do
  platform 'ubuntu'

  describe 'removes a group with an explicit action' do
    it { is_expected.to remove_group('explicit_action') }
    it { is_expected.to_not remove_group('not_explicit_action') }
  end

  describe 'removes a group with attributes' do
    it { is_expected.to_not remove_group('with_attributes').with(gid: 5678) }
  end

  describe 'removes a group when specifying the identity attribute' do
    it { is_expected.to remove_group('identity_attribute') }
  end
end

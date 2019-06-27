require 'chefspec'

describe 'group::manage' do
  platform 'ubuntu'

  describe 'manages a group with an explicit action' do
    it { is_expected.to manage_group('explicit_action') }
    it { is_expected.to_not manage_group('not_explicit_action') }
  end

  describe 'manages a group with attributes' do
    it { is_expected.to manage_group('with_attributes').with(gid: 1234) }
    it { is_expected.to_not manage_group('with_attributes').with(gid: 5678) }
  end

  describe 'manages a group when specifying the identity attribute' do
    it { is_expected.to manage_group('identity_attribute') }
  end
end

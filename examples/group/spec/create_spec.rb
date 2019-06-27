require 'chefspec'

describe 'group::create' do
  platform 'ubuntu'

  describe 'creates a group with the default action' do
    it { is_expected.to create_group('default_action') }
    it { is_expected.to_not create_group('not_default_action') }
  end

  describe 'creates a group with an explicit action' do
    it { is_expected.to create_group('explicit_action') }
  end

  describe 'creates a group with attributes' do
    it { is_expected.to create_group('with_attributes').with(gid: 1234) }
    it { is_expected.to_not create_group('with_attributes').with(gid: 5678) }
  end

  describe 'creates a group when specifying the identity attribute' do
    it { is_expected.to create_group('identity_attribute') }
  end
end

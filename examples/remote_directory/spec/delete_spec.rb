require 'chefspec'

describe 'remote_directory::delete' do
  platform 'ubuntu'

  describe 'deletes a remote_directory with an explicit action' do
    it { is_expected.to delete_remote_directory('/tmp/explicit_action') }
    it { is_expected.to_not delete_remote_directory('/tmp/not_explicit_action') }
  end

  describe 'deletes a remote_directory with attributes' do
    it { is_expected.to delete_remote_directory('/tmp/with_attributes').with(owner: 'owner') }
    it { is_expected.to_not delete_remote_directory('/tmp/with_attributes').with(owner: 'bacon') }
  end

  describe 'deletes a remote_directory when specifying the identity attribute' do
    it { is_expected.to delete_remote_directory('/tmp/identity_attribute') }
  end
end

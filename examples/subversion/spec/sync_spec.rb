require 'chefspec'

describe 'subversion::sync' do
  platform 'ubuntu'

  describe 'syncs a subversion with the default action' do
    it { is_expected.to sync_subversion('/tmp/default_action') }
    it { is_expected.to_not sync_subversion('/tmp/not_default_action') }
  end

  describe 'syncs a subversion with an explicit action' do
    it { is_expected.to sync_subversion('/tmp/explicit_action') }
  end

  describe 'syncs a subversion with attributes' do
    it { is_expected.to sync_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path') }
    it { is_expected.to_not sync_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path') }
  end

  describe 'syncs a subversion when specifying the identity attribute' do
    it { is_expected.to sync_subversion('/tmp/identity_attribute') }
  end
end

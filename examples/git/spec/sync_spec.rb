require 'chefspec'

describe 'git::sync' do
  platform 'ubuntu'

  describe 'syncs a git with the default action' do
    it { is_expected.to sync_git('/tmp/default_action') }
    it { is_expected.to_not sync_git('/tmp/not_default_action') }
  end

  describe 'syncs a git with an explicit action' do
    it { is_expected.to sync_git('/tmp/explicit_action') }
  end

  describe 'syncs a git with attributes' do
    it { is_expected.to sync_git('/tmp/with_attributes').with(repository: 'ssh://git.path') }
    it { is_expected.to_not sync_git('/tmp/with_attributes').with(repository: 'ssh://git.other_path') }
  end

  describe 'syncs a git when specifying the identity attribute' do
    it { is_expected.to sync_git('/tmp/identity_attribute') }
  end
end

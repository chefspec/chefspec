require 'chefspec'

describe 'git::export' do
  platform 'ubuntu'

  describe 'exports a git with an explicit action' do
    it { is_expected.to export_git('/tmp/explicit_action') }
    it { is_expected.to_not export_git('/tmp/not_explicit_action') }
  end

  describe 'exports a git with attributes' do
    it { is_expected.to export_git('/tmp/with_attributes').with(repository: 'ssh://git.path') }
    it { is_expected.to_not export_git('/tmp/with_attributes').with(repository: 'ssh://git.other_path') }
  end

  describe 'exports a git when specifying the identity attribute' do
    it { is_expected.to export_git('/tmp/identity_attribute') }
  end
end

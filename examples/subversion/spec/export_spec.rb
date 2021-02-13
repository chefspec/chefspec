require 'chefspec'

describe 'subversion::export' do
  platform 'ubuntu'

  describe 'exports a subversion with an explicit action' do
    it { is_expected.to export_subversion('/tmp/explicit_action') }
    it { is_expected.to_not export_subversion('/tmp/not_explicit_action') }
  end

  describe 'exports a subversion with attributes' do
    it { is_expected.to export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path') }
    it { is_expected.to_not export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path') }
  end

  describe 'exports a subversion when specifying the identity attribute' do
    it { is_expected.to export_subversion('/tmp/identity_attribute') }
  end
end

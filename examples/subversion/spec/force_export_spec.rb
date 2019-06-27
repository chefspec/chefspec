require 'chefspec'

describe 'subversion::force_export' do
  platform 'ubuntu'

  describe 'force_exports a subversion with an explicit action' do
    it { is_expected.to force_export_subversion('/tmp/explicit_action') }
    it { is_expected.to_not force_export_subversion('/tmp/not_explicit_action') }
  end

  describe 'force_exports a subversion with attributes' do
    it { is_expected.to force_export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path') }
    it { is_expected.to_not force_export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.other_path') }
  end

  describe 'force_exports a subversion when specifying the identity attribute' do
    it { is_expected.to force_export_subversion('/tmp/identity_attribute') }
  end
end

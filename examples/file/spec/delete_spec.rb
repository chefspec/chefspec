require 'chefspec'

describe 'file::delete' do
  platform 'ubuntu'

  describe 'deletes a file with an explicit action' do
    it { is_expected.to delete_file('/tmp/explicit_action') }
    it { is_expected.to_not delete_file('/tmp/not_explicit_action') }
  end

  describe 'deletes a file with attributes' do
    it { is_expected.to delete_file('/tmp/with_attributes').with(backup: false) }
    it { is_expected.to_not delete_file('/tmp/with_attributes').with(backup: true) }
  end

  describe 'deletes a file when specifying the identity attribute' do
    it { is_expected.to delete_file('specifying the identity attribute').with(path: '/tmp/identity_attribute') }
    it { is_expected.to_not delete_file('specifying the identity attribute').with(path: '/tmp/not_identity_attribute') }
  end
end

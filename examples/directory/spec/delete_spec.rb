require 'chefspec'

describe 'directory::delete' do
  platform 'ubuntu'

  describe 'deletes a directory with an explicit action' do
    it { is_expected.to delete_directory('/tmp/explicit_action') }
    it { is_expected.to_not delete_directory('/tmp/not_explicit_action') }
  end

  describe 'deletes a directory with attributes' do
    it {
      is_expected.to delete_directory('/tmp/with_attributes').with(
        user: 'user',
        group: 'group'
      )
    }

    it {
      is_expected.to_not delete_directory('/tmp/with_attributes').with(
        user: 'bacon',
        group: 'fat'
      )
    }
  end

  describe 'deletes a directory when specifying the identity attribute' do
    it { is_expected.to delete_directory('/tmp/identity_attribute') }
  end
end

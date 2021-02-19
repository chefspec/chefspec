require 'chefspec'

describe 'remote_file::touch' do
  platform 'ubuntu'

  describe 'touchs a remote_file with an explicit action' do
    it { is_expected.to touch_remote_file('/tmp/explicit_action') }
    it { is_expected.to_not touch_remote_file('/tmp/not_explicit_action') }
  end

  describe 'touchs a remote_file with attributes' do
    it { is_expected.to touch_remote_file('/tmp/with_attributes').with(owner: 'owner') }
    it { is_expected.to_not touch_remote_file('/tmp/with_attributes').with(owner: 'bacon') }
  end

  describe 'touchs a remote_file when specifying the identity attribute' do
    it { is_expected.to touch_remote_file('/tmp/identity_attribute') }
  end
end

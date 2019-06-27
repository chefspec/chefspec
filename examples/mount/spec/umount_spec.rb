require 'chefspec'

describe 'mount::umount' do
  platform 'ubuntu'

  describe 'umounts a mount with an explicit action' do
    it { is_expected.to umount_mount('/tmp/explicit_action') }
    it { is_expected.to_not umount_mount('/tmp/not_explicit_action') }
  end

  describe 'umounts a mount with attributes' do
    it { is_expected.to umount_mount('/tmp/with_attributes').with(dump: 3) }
    it { is_expected.to_not umount_mount('/tmp/with_attributes').with(dump: 5) }
  end
end

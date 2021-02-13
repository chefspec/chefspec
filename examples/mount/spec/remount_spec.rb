require "chefspec"

describe "mount::remount" do
  platform "ubuntu"

  describe "remounts a mount with an explicit action" do
    it { is_expected.to remount_mount("/tmp/explicit_action") }
    it { is_expected.to_not remount_mount("/tmp/not_explicit_action") }
  end

  describe "remounts a mount with attributes" do
    it { is_expected.to remount_mount("/tmp/with_attributes").with(dump: 3) }
    it { is_expected.to_not remount_mount("/tmp/with_attributes").with(dump: 5) }
  end
end

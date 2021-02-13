require "chefspec"

describe "mount::mount" do
  platform "ubuntu"

  describe "mounts a mount with the default action" do
    it { is_expected.to mount_mount("/tmp/default_action") }
    it { is_expected.to_not mount_mount("/tmp/not_default_action") }
  end

  describe "mounts a mount with an explicit action" do
    it { is_expected.to mount_mount("/tmp/explicit_action") }
  end

  describe "mounts a mount with attributes" do
    it { is_expected.to mount_mount("/tmp/with_attributes").with(dump: 3) }
    it { is_expected.to_not mount_mount("/tmp/with_attributes").with(dump: 5) }
  end
end

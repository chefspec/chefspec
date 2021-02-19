require "chefspec"

describe "file::touch" do
  platform "ubuntu"

  describe "touches a file with an explicit action" do
    it { is_expected.to touch_file("/tmp/explicit_action") }
    it { is_expected.to_not touch_file("/tmp/not_explicit_action") }
  end

  describe "touches a file with attributes" do
    it { is_expected.to touch_file("/tmp/with_attributes").with(backup: false) }
    it { is_expected.to_not touch_file("/tmp/with_attributes").with(backup: true) }
  end

  describe "touches a file when specifying the identity attribute" do
    it { is_expected.to touch_file("/tmp/identity_attribute") }
  end
end

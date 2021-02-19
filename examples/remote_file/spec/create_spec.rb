require "chefspec"

describe "remote_file::create" do
  platform "ubuntu"

  describe "creates a remote_file with the default action" do
    it { is_expected.to create_remote_file("/tmp/default_action") }
    it { is_expected.to_not create_remote_file("/tmp/not_default_action") }
  end

  describe "creates a remote_file with an explicit action" do
    it { is_expected.to create_remote_file("/tmp/explicit_action") }
  end

  describe "creates a remote_file with attributes" do
    it { is_expected.to create_remote_file("/tmp/with_attributes").with(owner: "owner") }
    it { is_expected.to_not create_remote_file("/tmp/with_attributes").with(owner: "bacon") }
  end

  describe "creates a remote_file when specifying the identity attribute" do
    it { is_expected.to create_remote_file("/tmp/identity_attribute") }
  end
end

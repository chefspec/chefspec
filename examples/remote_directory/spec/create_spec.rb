require "chefspec"

describe "remote_directory::create" do
  platform "ubuntu"

  describe "creates a remote_directory with the default action" do
    it { is_expected.to create_remote_directory("/tmp/default_action") }
    it { is_expected.to_not create_remote_directory("/tmp/not_default_action") }
  end

  describe "creates a remote_directory with an explicit action" do
    it { is_expected.to create_remote_directory("/tmp/explicit_action") }
  end

  describe "creates a remote_directory with attributes" do
    it { is_expected.to create_remote_directory("/tmp/with_attributes").with(owner: "owner") }
    it { is_expected.to_not create_remote_directory("/tmp/with_attributes").with(owner: "bacon") }
  end

  describe "creates a remote_directory when specifying the identity attribute" do
    it { is_expected.to create_remote_directory("/tmp/identity_attribute") }
  end
end

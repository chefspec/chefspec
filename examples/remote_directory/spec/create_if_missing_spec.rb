require "chefspec"

describe "remote_directory::create_if_missing" do
  platform "ubuntu"

  describe "creates a remote_directory with an explicit action" do
    it { is_expected.to create_remote_directory_if_missing("/tmp/explicit_action") }
    it { is_expected.to_not create_remote_directory_if_missing("/tmp/not_explicit_action") }
  end

  describe "creates a remote_directory with attributes" do
    it { is_expected.to create_remote_directory_if_missing("/tmp/with_attributes").with(owner: "owner") }
    it { is_expected.to_not create_remote_directory_if_missing("/tmp/with_attributes").with(owner: "bacon") }
  end

  describe "creates a remote_directory when specifying the identity attribute" do
    it { is_expected.to create_remote_directory_if_missing("/tmp/identity_attribute") }
  end
end

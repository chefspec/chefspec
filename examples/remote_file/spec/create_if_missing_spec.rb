require "chefspec"

describe "remote_file::create_if_missing" do
  platform "ubuntu"

  describe "creates a remote_file with an explicit action" do
    it { is_expected.to create_remote_file_if_missing("/tmp/explicit_action") }
    it { is_expected.to_not create_remote_file_if_missing("/tmp/not_explicit_action") }
  end

  describe "creates a remote_file with attributes" do
    it { is_expected.to create_remote_file_if_missing("/tmp/with_attributes").with(owner: "owner") }
    it { is_expected.to_not create_remote_file_if_missing("/tmp/with_attributes").with(owner: "bacon") }
  end

  describe "creates a remote_file when specifying the identity attribute" do
    it { is_expected.to create_remote_file_if_missing("/tmp/identity_attribute") }
  end
end

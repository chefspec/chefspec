require "chefspec"

describe "remote_file::delete" do
  platform "ubuntu"

  describe "deletes a remote_file with an explicit action" do
    it { is_expected.to delete_remote_file("/tmp/explicit_action") }
    it { is_expected.to_not delete_remote_file("/tmp/not_explicit_action") }
  end

  describe "deletes a remote_file with attributes" do
    it { is_expected.to delete_remote_file("/tmp/with_attributes").with(owner: "owner") }
    it { is_expected.to_not delete_remote_file("/tmp/with_attributes").with(owner: "bacon") }
  end

  describe "deletes a remote_file when specifying the identity attribute" do
    it { is_expected.to delete_remote_file("/tmp/identity_attribute") }
  end
end

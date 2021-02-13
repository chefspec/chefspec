require "chefspec"

describe "directory::create" do
  platform "ubuntu"

  describe "creates a directory with the default action" do
    it { is_expected.to create_directory("/tmp/default_action") }
    it { is_expected.to_not create_directory("/tmp/not_default_action") }
  end

  describe "creates a directory with an explicit action" do
    it { is_expected.to create_directory("/tmp/explicit_action") }
  end

  describe "creates a directory with attributes" do
    it {
      is_expected.to create_directory("/tmp/with_attributes").with(
        user: "user",
        group: "group"
      )
    }

    it {
      is_expected.to_not create_directory("/tmp/with_attributes").with(
        user: "bacon",
        group: "fat"
      )
    }
  end

  describe "creates a directory with windows rights" do
    it { is_expected.to create_directory('c:\temp\with_windows_rights').with(rights: [{ permissions: :read_execute, principals: "Users", applies_to_children: true }]) }
  end

  describe "creates a directory when specifying the identity attribute" do
    it { is_expected.to create_directory("/tmp/identity_attribute") }
  end
end

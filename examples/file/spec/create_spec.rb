require "chefspec"

describe "file::create" do
  platform "ubuntu"

  describe "creates a file with the default action" do
    it { is_expected.to create_file("/tmp/default_action") }
    it { is_expected.to_not create_file("/tmp/not_default_action") }
  end

  describe "creates a file with an explicit action" do
    it { is_expected.to create_file("/tmp/explicit_action") }
  end

  describe "creates a file with attributes" do
    it {
      is_expected.to create_file("/tmp/with_attributes").with(
        user: "user",
        group: "group",
        backup: false
      )
    }

    it {
      is_expected.to_not create_file("/tmp/with_attributes").with(
        user: "bacon",
        group: "fat",
        backup: true
      )
    }
  end

  describe "creates a file when specifying the identity attribute" do
    it { is_expected.to create_file("/tmp/identity_attribute") }
  end
end

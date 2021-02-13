require "chefspec"

describe "file::create_if_missing" do
  platform "ubuntu"

  describe "creates a file with an explicit action" do
    it { is_expected.to create_file_if_missing("/tmp/explicit_action") }
    it { is_expected.to_not create_file_if_missing("/tmp/not_explicit_action") }
  end

  describe "creates a file with attributes" do
    it {
      is_expected.to create_file_if_missing("/tmp/with_attributes").with(
        user: "user",
        group: "group",
        backup: false
      )
    }

    it {
      is_expected.to_not create_file_if_missing("/tmp/with_attributes").with(
        user: "bacon",
        group: "fat",
        backup: true
      )
    }
  end

  describe "creates a file when specifying the identity attribute" do
    it { is_expected.to create_file_if_missing("/tmp/identity_attribute") }
  end
end

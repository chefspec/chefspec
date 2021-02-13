require "chefspec"

describe "cookbook_file::create" do
  platform "ubuntu"

  describe "creates a cookbook_file with the default action" do
    it { is_expected.to create_cookbook_file("/tmp/default_action") }
    it { is_expected.to_not create_cookbook_file("/tmp/not_default_action") }
  end

  describe "creates a cookbook_file with an explicit action" do
    it { is_expected.to create_cookbook_file("/tmp/explicit_action") }
  end

  describe "creates a cookbook_file with attributes" do
    it {
      is_expected.to create_cookbook_file("/tmp/with_attributes").with(
        user: "user",
        group: "group",
        backup: false
      )
    }

    it {
      is_expected.to_not create_cookbook_file_if_missing("/tmp/with_attributes").with(
        user: "bacon",
        group: "fat",
        backup: true
      )
    }
  end

  describe "creates a cookbook_file when specifying the identity attribute" do
    it { is_expected.to create_cookbook_file("/tmp/identity_attribute") }
  end
end

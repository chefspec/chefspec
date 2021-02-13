require "chefspec"

describe "user::create" do
  platform "ubuntu"

  describe "creates a user with the default action" do
    it { is_expected.to create_user("default_action") }
    it { is_expected.to_not create_user("not_default_action") }
  end

  describe "creates a user with an explicit action" do
    it { is_expected.to create_user("explicit_action") }
  end

  describe "creates a user with attributes" do
    it { is_expected.to create_user("with_attributes").with(uid: "1234") }
    it { is_expected.to_not create_user("with_attributes").with(uid: "5678") }
  end

  describe "creates a user when specifying the identity attribute" do
    it { is_expected.to create_user("identity_attribute") }
  end
end

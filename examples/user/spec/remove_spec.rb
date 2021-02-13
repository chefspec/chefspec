require "chefspec"

describe "user::remove" do
  platform "ubuntu"

  describe "removes a user with an explicit action" do
    it { is_expected.to remove_user("explicit_action") }
    it { is_expected.to_not remove_user("not_explicit_action") }
  end

  describe "removes a user with attributes" do
    it { is_expected.to remove_user("with_attributes").with(uid: "1234") }
    it { is_expected.to_not remove_user("with_attributes").with(uid: "5678") }
  end

  describe "removes a user when specifying the identity attribute" do
    it { is_expected.to remove_user("identity_attribute") }
  end
end

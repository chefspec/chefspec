require "chefspec"

describe "user::modify" do
  platform "ubuntu"

  describe "modifys a user with an explicit action" do
    it { is_expected.to modify_user("explicit_action") }
    it { is_expected.to_not modify_user("not_explicit_action") }
  end

  describe "modifys a user with attributes" do
    it { is_expected.to modify_user("with_attributes").with(uid: "1234") }
    it { is_expected.to_not modify_user("with_attributes").with(uid: "5678") }
  end

  describe "modifys a user when specifying the identity attribute" do
    it { is_expected.to modify_user("identity_attribute") }
  end
end

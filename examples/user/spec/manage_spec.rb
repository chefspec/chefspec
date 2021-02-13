require "chefspec"

describe "user::manage" do
  platform "ubuntu"

  describe "manages a user with an explicit action" do
    it { is_expected.to manage_user("explicit_action") }
    it { is_expected.to_not manage_user("not_explicit_action") }
  end

  describe "manages a user with attributes" do
    it { is_expected.to manage_user("with_attributes").with(uid: "1234") }
    it { is_expected.to_not manage_user("with_attributes").with(uid: "5678") }
  end

  describe "manages a user when specifying the identity attribute" do
    it { is_expected.to manage_user("identity_attribute") }
  end
end

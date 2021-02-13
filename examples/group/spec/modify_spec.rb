require "chefspec"

describe "group::modify" do
  platform "ubuntu"

  describe "modifies a group with an explicit action" do
    it { is_expected.to modify_group("explicit_action") }
    it { is_expected.to_not modify_group("not_explicit_action") }
  end

  describe "modifies a group with attributes" do
    it { is_expected.to modify_group("with_attributes").with(gid: 1234) }
    it { is_expected.to_not modify_group("with_attributes").with(gid: 5678) }
  end

  describe "modifies a group when specifying the identity attribute" do
    it { is_expected.to modify_group("identity_attribute") }
  end
end

require "chefspec"

describe "env::modify" do
  platform "windows"
  describe "modifies a env with an explicit action" do
    it { is_expected.to modify_env("explicit_action") }
    it { is_expected.to_not modify_env("not_explicit_action") }
  end

  describe "modifies a env with attributes" do
    it { is_expected.to modify_env("with_attributes").with(value: "value") }
    it { is_expected.to_not modify_env("with_attributes").with(value: "not_value") }
  end

  describe "modifies a env when specifying the identity attribute" do
    it { is_expected.to modify_env("identity_attribute") }
  end
end

require "chefspec"

describe "env::delete" do
  platform "windows"

  describe "deletes a env with an explicit action" do
    it { is_expected.to delete_env("explicit_action") }
    it { is_expected.to_not delete_env("not_explicit_action") }
  end

  describe "deletes a env with attributes" do
    it { is_expected.to delete_env("with_attributes").with(value: "value") }
    it { is_expected.to_not delete_env("with_attributes").with(value: "not_value") }
  end

  describe "deletes a env when specifying the identity attribute" do
    it { is_expected.to delete_env("identity_attribute") }
  end
end

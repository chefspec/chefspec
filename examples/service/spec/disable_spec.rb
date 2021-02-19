require "chefspec"

describe "service::disable" do
  platform "ubuntu"

  describe "disables a service with an explicit action" do
    it { is_expected.to disable_service("explicit_action") }
    it { is_expected.to_not disable_service("not_explicit_action") }
  end

  describe "disables a service with attributes" do
    it { is_expected.to disable_service("with_attributes").with(pattern: "pattern") }
    it { is_expected.to_not disable_service("with_attributes").with(pattern: "bacon") }
  end

  describe "disables a service when specifying the identity attribute" do
    it { is_expected.to disable_service("identity_attribute") }
  end
end

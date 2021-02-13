require "chefspec"

describe "service::enable" do
  platform "ubuntu"

  describe "enables a service with an explicit action" do
    it { is_expected.to enable_service("explicit_action") }
    it { is_expected.to_not enable_service("not_explicit_action") }
  end

  describe "enables a service with attributes" do
    it { is_expected.to enable_service("with_attributes").with(pattern: "pattern") }
    it { is_expected.to_not enable_service("with_attributes").with(pattern: "bacon") }
  end

  describe "enables a service when specifying the identity attribute" do
    it { is_expected.to enable_service("identity_attribute") }
  end
end

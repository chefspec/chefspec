require "chefspec"

describe "service::start" do
  platform "ubuntu"

  describe "starts a service with an explicit action" do
    it { is_expected.to start_service("explicit_action") }
    it { is_expected.to_not start_service("not_explicit_action") }
  end

  describe "starts a service with attributes" do
    it { is_expected.to start_service("with_attributes").with(pattern: "pattern") }
    it { is_expected.to_not start_service("with_attributes").with(pattern: "bacon") }
  end

  describe "starts a service when specifying the identity attribute" do
    it { is_expected.to start_service("identity_attribute") }
  end
end

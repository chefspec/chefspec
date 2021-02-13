require "chefspec"

describe "service::stop" do
  platform "ubuntu"

  describe "stops a service with an explicit action" do
    it { is_expected.to stop_service("explicit_action") }
    it { is_expected.to_not stop_service("not_explicit_action") }
  end

  describe "stops a service with attributes" do
    it { is_expected.to stop_service("with_attributes").with(pattern: "pattern") }
    it { is_expected.to_not stop_service("with_attributes").with(pattern: "bacon") }
  end

  describe "stops a service when specifying the identity attribute" do
    it { is_expected.to stop_service("identity_attribute") }
  end
end

require "chefspec"

describe "windows_service::disable" do
  platform "windows"

  describe "disables a windows_service with an explicit action" do
    it { is_expected.to disable_windows_service("explicit_action") }
    it { is_expected.to_not disable_windows_service("not_explicit_action") }
  end

  describe "disables a windows_service with attributes" do
    it { is_expected.to disable_windows_service("with_attributes").with(pattern: "pattern") }
    it { is_expected.to_not disable_windows_service("with_attributes").with(pattern: "bacon") }
  end

  describe "disables a windows_service when specifying the identity attribute" do
    it { is_expected.to disable_windows_service("identity_attribute") }
  end
end

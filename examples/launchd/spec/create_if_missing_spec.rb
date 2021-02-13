require "chefspec"

describe "launchd::create_if_missing" do
  platform "mac_os_x"

  describe "creates a launchd daemon if missing with an explicit action" do
    it { is_expected.to create_if_missing_launchd("explicit_action") }
    it { is_expected.to_not create_if_missing_launchd("not_explicit_action") }
  end
end

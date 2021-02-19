require "chefspec"

describe "launchd::disable" do
  platform "mac_os_x"

  describe "disables a launchd daemon with an explicit action" do
    it { is_expected.to disable_launchd("explicit_action") }
    it { is_expected.to_not disable_launchd("not_explicit_action") }
  end
end

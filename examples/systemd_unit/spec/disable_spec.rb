require "chefspec"

describe "systemd_unit::disable" do
  platform "ubuntu"

  describe "disables a systemd unit with an explicit action" do
    it { is_expected.to disable_systemd_unit("explicit_action") }
    it { is_expected.to_not disable_systemd_unit("not_explicit_action") }
  end
end

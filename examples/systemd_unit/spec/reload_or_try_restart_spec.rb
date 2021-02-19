require "chefspec"

describe "systemd_unit::reload_or_try_restart" do
  platform "ubuntu"

  describe "reloads or tries to restart a systemd_unit daemon with an explicit action" do
    it { is_expected.to reload_or_try_restart_systemd_unit("explicit_action") }
    it { is_expected.to_not reload_or_try_restart_systemd_unit("not_explicit_action") }
  end
end

require "chefspec"

describe "systemd_unit::try_restart" do
  platform "ubuntu"

  describe "tries to restart a systemd_unit daemon with an explicit action" do
    it { is_expected.to try_restart_systemd_unit("explicit_action") }
    it { is_expected.to_not try_restart_systemd_unit("not_explicit_action") }
  end
end

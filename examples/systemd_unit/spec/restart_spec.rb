require "chefspec"

describe "systemd_unit::restart" do
  platform "ubuntu"

  describe "restarts a systemd_unit daemon with an explicit action" do
    it { is_expected.to restart_systemd_unit("explicit_action") }
    it { is_expected.to_not restart_systemd_unit("not_explicit_action") }
  end
end

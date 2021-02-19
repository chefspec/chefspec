require "chefspec"

describe "systemd_unit::start" do
  platform "ubuntu"

  describe "starts a systemd_unit daemon with an explicit action" do
    it { is_expected.to start_systemd_unit("explicit_action") }
    it { is_expected.to_not start_systemd_unit("not_explicit_action") }
  end
end

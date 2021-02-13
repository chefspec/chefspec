require "chefspec"

describe "systemd_unit::enable" do
  platform "ubuntu"

  describe "enables a systemd unit with an explicit action" do
    it { is_expected.to enable_systemd_unit("explicit_action") }
    it { is_expected.to_not enable_systemd_unit("not_explicit_action") }
  end
end

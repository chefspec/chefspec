require "chefspec"

describe "reboot::request" do
  platform "ubuntu"

  describe "runs a request_reboot" do
    it { is_expected.to request_reboot("explicit_action") }
  end
end

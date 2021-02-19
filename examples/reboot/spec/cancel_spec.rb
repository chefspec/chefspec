require "chefspec"

describe "reboot::cancel" do
  platform "ubuntu"

  describe "runs a cancel_reboot" do
    it { is_expected.to cancel_reboot("explicit cancel") }
  end
end

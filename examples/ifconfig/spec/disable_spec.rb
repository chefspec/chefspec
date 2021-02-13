require "chefspec"

describe "ifconfig::disable" do
  platform "ubuntu"

  describe "disables a ifconfig with an explicit action" do
    it { is_expected.to disable_ifconfig("10.0.0.2") }
    it { is_expected.to_not disable_ifconfig("10.0.0.10") }
  end

  describe "disables a ifconfig with attributes" do
    it { is_expected.to disable_ifconfig("10.0.0.3").with(device: "en0") }
    it { is_expected.to_not disable_ifconfig("10.0.0.3").with(device: "en1") }
  end
end

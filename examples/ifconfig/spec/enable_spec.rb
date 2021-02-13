require "chefspec"

describe "ifconfig::enable" do
  platform "ubuntu"

  describe "enables a ifconfig with an explicit action" do
    it { is_expected.to enable_ifconfig("10.0.0.2") }
    it { is_expected.to_not enable_ifconfig("10.0.0.10") }
  end

  describe "enables a ifconfig with attributes" do
    it { is_expected.to enable_ifconfig("10.0.0.3").with(device: "en0") }
    it { is_expected.to_not enable_ifconfig("10.0.0.3").with(device: "en1") }
  end
end

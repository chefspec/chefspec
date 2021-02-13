require "chefspec"

describe "ifconfig::add" do
  platform "ubuntu"

  describe "adds a ifconfig with the default action" do
    it { is_expected.to add_ifconfig("10.0.0.1") }
    it { is_expected.to_not add_ifconfig("10.0.0.10") }
  end

  describe "adds a ifconfig with an explicit action" do
    it { is_expected.to add_ifconfig("10.0.0.2") }
  end

  describe "adds a ifconfig with attributes" do
    it { is_expected.to add_ifconfig("10.0.0.3").with(device: "en0") }
    it { is_expected.to_not add_ifconfig("10.0.0.3").with(device: "en1") }
  end
end

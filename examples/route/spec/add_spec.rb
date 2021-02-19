require "chefspec"

describe "route::add" do
  platform "ubuntu"

  describe "adds a route with the default action" do
    it { is_expected.to add_route("10.0.0.1") }
    it { is_expected.to_not add_route("10.0.0.10") }
  end

  describe "adds a route with an explicit action" do
    it { is_expected.to add_route("10.0.0.2") }
  end

  describe "adds a route with attributes" do
    it { is_expected.to add_route("10.0.0.3").with(gateway: "10.0.0.0") }
    it { is_expected.to_not add_route("10.0.0.3").with(gateway: "10.0.0.100") }
  end

  describe "adds a route when specifying the identity attribute" do
    it { is_expected.to add_route("10.0.0.4") }
  end
end

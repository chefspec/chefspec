require "chefspec"

describe "apt_package::unlock" do
  platform "ubuntu"

  describe "unlocks an apt_package with an explicit action" do
    it { is_expected.to unlock_apt_package("explicit_action") }
    it { is_expected.to_not unlock_apt_package("not_explicit_action") }
  end

  describe "unlocks an apt_package with attributes" do
    it { is_expected.to unlock_apt_package("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not unlock_apt_package("with_attributes").with(version: "1.2.3") }
  end

  describe "unlocks an apt_package when specifying the identity attribute" do
    it { is_expected.to unlock_apt_package("identity_attribute") }
  end
end

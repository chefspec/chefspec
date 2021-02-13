require "chefspec"

describe "chef_gem::reconfig" do
  platform "ubuntu"

  describe "reconfigs a chef_gem with an explicit action" do
    it { is_expected.to reconfig_chef_gem("explicit_action") }
    it { is_expected.to_not reconfig_chef_gem("not_explicit_action") }
  end

  describe "reconfigs a chef_gem with attributes" do
    it { is_expected.to reconfig_chef_gem("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not reconfig_chef_gem("with_attributes").with(version: "1.2.3") }
  end

  describe "reconfigs a chef_gem when specifying the identity attribute" do
    it { is_expected.to reconfig_chef_gem("identity_attribute") }
  end
end

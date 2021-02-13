require "chefspec"

describe "chef_gem::purge" do
  platform "ubuntu"

  describe "purges a chef_gem with an explicit action" do
    it { is_expected.to purge_chef_gem("explicit_action") }
    it { is_expected.to_not purge_chef_gem("not_explicit_action") }
  end

  describe "purges a chef_gem with attributes" do
    it { is_expected.to purge_chef_gem("with_attributes").with(version: "1.0.0") }
    it { is_expected.to_not purge_chef_gem("with_attributes").with(version: "1.2.3") }
  end

  describe "purges a chef_gem when specifying the identity attribute" do
    it { is_expected.to purge_chef_gem("identity_attribute") }
  end
end

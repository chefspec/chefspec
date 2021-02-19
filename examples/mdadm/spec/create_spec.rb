require "chefspec"

describe "mdadm::create" do
  platform "ubuntu"

  describe "creates a mdadm with the default action" do
    it { is_expected.to create_mdadm("default_action") }
    it { is_expected.to_not create_mdadm("not_default_action") }
  end

  describe "creates a mdadm with an explicit action" do
    it { is_expected.to create_mdadm("explicit_action") }
  end

  describe "creates a mdadm with attributes" do
    it { is_expected.to create_mdadm("with_attributes").with(chunk: 8) }
    it { is_expected.to_not create_mdadm("with_attributes").with(chunk: 3) }
  end

  describe "creates a mdadm when specifying the identity attribute" do
    it { is_expected.to create_mdadm("identity_attribute") }
  end
end

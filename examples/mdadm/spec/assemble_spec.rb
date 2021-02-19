require "chefspec"

describe "mdadm::assemble" do
  platform "ubuntu"

  describe "assembles a mdadm with an explicit action" do
    it { is_expected.to assemble_mdadm("explicit_action") }
    it { is_expected.to_not assemble_mdadm("not_explicit_action") }
  end

  describe "assembles a mdadm with attributes" do
    it { is_expected.to assemble_mdadm("with_attributes").with(chunk: 8) }
    it { is_expected.to_not assemble_mdadm("with_attributes").with(chunk: 3) }
  end

  describe "assembles a mdadm when specifying the identity attribute" do
    it { is_expected.to assemble_mdadm("identity_attribute") }
  end
end

require "chefspec"

describe "ruby_block::run" do
  platform "ubuntu"

  describe "runs a ruby_block with the default action" do
    it { is_expected.to run_ruby_block("default_action") }
    it { is_expected.to_not run_ruby_block("not_default_action") }
  end

  describe "runs a ruby_block with an explicit action" do
    it { is_expected.to run_ruby_block("explicit_action") }
  end

  describe "runs a ruby_block when specifying the identity attribute" do
    it { is_expected.to run_ruby_block("identity_attribute") }
  end
end

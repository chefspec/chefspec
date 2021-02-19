require "chefspec"

describe "custom_matcher::remove" do
  platform "ubuntu"

  describe "removes a custom_matcher with an explicit action" do
    it { is_expected.to remove_custom_matcher_thing("explicit_action") }
    it { is_expected.to_not remove_custom_matcher_thing("not_explicit_action") }
  end

  describe "removes a custom_matcher with attributes" do
    it { is_expected.to remove_custom_matcher_thing("with_attributes").with(config: true) }
    it { is_expected.to_not remove_custom_matcher_thing("with_attributes").with(config: false) }
  end

  describe "removes a custom_matcher when specifying the identity attribute" do
    it { is_expected.to remove_custom_matcher_thing("identity_attribute") }
  end

  describe "defines a runner method" do
    it { is_expected.to respond_to(:custom_matcher_thing) }
  end
end

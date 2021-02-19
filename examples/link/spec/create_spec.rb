require "chefspec"

describe "link::create" do
  platform "ubuntu"

  describe "creates a link with the default action" do
    it { is_expected.to create_link("/tmp/default_action") }
    it { is_expected.to_not create_link("/tmp/not_default_action") }
  end

  describe "creates a link with an explicit action" do
    it { is_expected.to create_link("/tmp/explicit_action") }
  end

  describe "creates a link with attributes" do
    it { is_expected.to create_link("/tmp/with_attributes").with(to: "destination") }
    it { is_expected.to_not create_link("/tmp/with_attributes").with(to: "other_destination") }
  end

  describe "creates a link when specifying the identity attribute" do
    it { is_expected.to create_link("/tmp/identity_attribute") }
  end
end

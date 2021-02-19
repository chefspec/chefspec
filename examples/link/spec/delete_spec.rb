require "chefspec"

describe "link::delete" do
  platform "ubuntu"

  describe "deletes a link with an explicit action" do
    it { is_expected.to delete_link("/tmp/explicit_action") }
    it { is_expected.to_not delete_link("/tmp/not_explicit_action") }
  end

  describe "deletes a link with attributes" do
    it { is_expected.to delete_link("/tmp/with_attributes").with(to: "destination") }
    it { is_expected.to_not delete_link("/tmp/with_attributes").with(to: "other_destination") }
  end

  describe "deletes a link when specifying the identity attribute" do
    it { is_expected.to delete_link("/tmp/identity_attribute") }
  end
end

require "chefspec"

describe "template::delete" do
  platform "ubuntu"

  describe "deletes a template with an explicit action" do
    it { is_expected.to delete_template("/tmp/explicit_action") }
    it { is_expected.to_not delete_template("/tmp/not_explicit_action") }
  end

  describe "deletes a template with attributes" do
    it { is_expected.to delete_template("/tmp/with_attributes").with(backup: false) }
    it { is_expected.to_not delete_template("/tmp/with_attributes").with(backup: true) }
  end

  describe "deletes a template when specifying the identity attribute" do
    it { is_expected.to delete_template("/tmp/identity_attribute") }
  end
end

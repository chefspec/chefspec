require "chefspec"

describe "subversion::checkout" do
  platform "ubuntu"

  describe "checkouts a subversion with an explicit action" do
    it { is_expected.to checkout_subversion("/tmp/explicit_action") }
    it { is_expected.to_not checkout_subversion("/tmp/not_explicit_action") }
  end

  describe "checkouts a subversion with attributes" do
    it { is_expected.to checkout_subversion("/tmp/with_attributes").with(repository: "ssh://subversion.path") }
    it { is_expected.to_not checkout_subversion("/tmp/with_attributes").with(repository: "ssh://subversion.other_path") }
  end

  describe "checkouts a subversion when specifying the identity attribute" do
    it { is_expected.to checkout_subversion("/tmp/identity_attribute") }
  end
end

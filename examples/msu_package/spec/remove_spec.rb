require "chefspec"

if defined?(Chef::Resource::MsuPackage)
  describe "msu_package::remove" do
    platform "windows"

    describe "removes a msu_package with an explicit action" do
      it { is_expected.to remove_msu_package("explicit_action") }
      it { is_expected.to_not remove_msu_package("not_explicit_action") }
    end

    describe "removes a msu_package with attributes" do
      it { is_expected.to remove_msu_package("with_attributes").with(version: "1.0.0") }
      it { is_expected.to_not remove_msu_package("with_attributes").with(version: "1.2.3") }
    end

    describe "removes a msu_package when specifying the identity attribute" do
      it { is_expected.to remove_msu_package("identity_attribute") }
    end
  end
end

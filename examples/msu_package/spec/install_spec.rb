require "chefspec"

if defined?(Chef::Resource::MsuPackage)
  describe "msu_package::install" do
    platform "windows"

    describe "installs a msu_package with the default action" do
      it { is_expected.to install_msu_package("default_action") }
      it { is_expected.to_not install_msu_package("not_default_action") }
    end

    describe "installs a msu_package with an explicit action" do
      it { is_expected.to install_msu_package("explicit_action") }
    end

    describe "installs a msu_package with attributes" do
      it { is_expected.to install_msu_package("with_attributes").with(version: "1.0.0") }
      it { is_expected.to_not install_msu_package("with_attributes").with(version: "1.2.3") }
    end

    describe "installs a msu_package when specifying the identity attribute" do
      it { is_expected.to install_msu_package("identity_attribute") }
    end
  end
end

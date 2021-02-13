require "chefspec"

describe "chocolatey_package::upgrade" do
  platform "windows"

  describe "upgrades a package" do
    it { is_expected.to upgrade_chocolatey_package("7zip") }
  end

  describe "upgrades a specific version of a package with options" do
    it {
      is_expected.to upgrade_chocolatey_package("git").with(
        version: %w{2.7.1}
      )
    }
  end
end

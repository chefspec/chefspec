require "chefspec"

describe "chocolatey_package::install" do
  platform "windows"

  describe "installs a package" do
    it { is_expected.to install_chocolatey_package("7zip") }
  end

  describe "installs a specific version of a package with options" do
    it {
      is_expected.to install_chocolatey_package("git").with(
        version: %w{2.7.1},
        options: "--params /GitAndUnixToolsOnPath"
      )
    }
  end
end

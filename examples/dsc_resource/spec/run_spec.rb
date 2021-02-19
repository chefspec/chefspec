require "chefspec"

describe "dsc_resource::run" do
  platform "windows"

  describe "runs dsc_resource with the archive resource" do
    it {
      is_expected.to run_dsc_resource("archive resource").with(
        resource: :archive,
        properties: {
          ensure: "present",
          path: 'C:\Users\Public\Documents\example.zip',
          destination: 'C:\Users\Public\Documents\ExtractionPath',
        }
      )
    }
  end

  describe "runs dsc_resource with the group resource" do
    it {
      is_expected.to run_dsc_resource("group resource").with(
        resource: :group,
        properties: {
          groupname: "demo1",
          ensure: "present",
        }
      )
    }
  end

  describe "runs dsc_resource with the user resource" do
    it {
      is_expected.to run_dsc_resource("user resource").with(
        resource: :user,
        properties: {
          username: "Foobar1",
          fullname: "Foobar1",
          password: "P@assword!",
          ensure: "present",
        }
      )
    }
  end
end

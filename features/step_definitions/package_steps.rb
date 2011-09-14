Given /^a Chef cookbook with a recipe that declares a package resource$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      package "package_does_not_exist" do
        action :install
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that declares a package resource at a fixed version$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      package "package_does_not_exist" do
        version "1.2.3"
        action :install
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that upgrades a package$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      package "package_does_not_exist" do
        action :upgrade
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that removes a package$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      package "package_does_not_exist" do
        action :remove
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that purges a package$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      package "package_does_not_exist" do
        action :purge
      end
    """
  }
end

Given /^the recipe has a spec example that expects the package to be installed$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should install package_does_not_exist" do
          @chef_run.should install_package "package_does_not_exist"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the package to be upgraded/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should upgrade package_does_not_exist" do
          @chef_run.should upgrade_package "package_does_not_exist"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the package to be removed$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should remove package_does_not_exist" do
          @chef_run.should remove_package "package_does_not_exist"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the package to be purged/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should purge package_does_not_exist" do
          @chef_run.should purge_package "package_does_not_exist"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the package to be installed at that version$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should install package_does_not_exist at a specific version" do
          @chef_run.should install_package_at_version "package_does_not_exist", "1.2.3"
        end
      end
    """
  }
end

Then /^the package will not have been installed$/ do
  # package installation would fail
end

Then /^the package will not have been upgraded$/ do
  # package upgrade would fail
end

Then /^the package will not have been removed$/ do
  # package removal would fail
end

Then /^the package will not have been purged$/ do
  # package purge would fail
end


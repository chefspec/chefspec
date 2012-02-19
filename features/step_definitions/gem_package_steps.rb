Given /^a Chef cookbook with a recipe that declares a gem package resource$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist" do
        action :install
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that declares a gem package resource with no action specified$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist"
    """
  }
end

Given /^a Chef cookbook with a recipe that declares a gem_package resource at a fixed version$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist" do
        version "1.2.3"
        action :install
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that declares a gem package resource at a fixed version with no action specified$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist" do
        version "1.2.3"
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that upgrades a gem package$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist" do
        action :upgrade
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that removes a gem package$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist" do
        action :remove
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that purges a gem package$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      gem_package "gem_package_does_not_exist" do
        action :purge
      end
    """
  }
end

Given /^the recipe has a spec example that expects the gem package to be installed$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let (:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should install package_does_not_exist" do
          chef_run.should install_gem_package 'gem_package_does_not_exist'
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the gem package to be upgraded/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let (:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should upgrade gem_package_does_not_exist" do
          chef_run.should upgrade_gem_package 'package_does_not_exist'
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the gem package to be removed$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let (:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should remove gem_package_does_not_exist" do
          chef_run.should remove_gem_package 'gem_package_does_not_exist'
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the gem package to be purged/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let (:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should purge gem_package_does_not_exist" do
          chef_run.should purge_gem_package 'package_does_not_exist'
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the gem package to be installed at that version$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let (:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should install gem_package_does_not_exist at a specific version" do
          chef_run.should install_gem_package_at_version 'package_does_not_exist', '1.2.3'
        end
      end
    """
  }
end

Then /^the gem package will not have been installed$/ do
  # gem package installation would fail
end

Then /^the gem package will not have been upgraded$/ do
  # gem package upgrade would fail
end

Then /^the gem package will not have been removed$/ do
  # gem package removal would fail
end

Then /^the gem package will not have been purged$/ do
  # gem package purge would fail
end


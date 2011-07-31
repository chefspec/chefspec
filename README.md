# ChefSpec
ChefSpec is a gem that makes it easy to write [RSpec](http://rspec.info/)  examples for
[Opscode Chef](http://www.opscode.com/chef/) cookbooks. Get fast feedback on cookbook changes before you spin up a node to do integration testing against.

ChefSpec runs your cookbook but without converging the node that your examples are being executed on. This allows you
to write specs that make assertions about the created resources given the combination of your recipes and arbitrary node
attributes that you provide.

# Compatibility
**This is alpha-quality at the moment**. The API is likely to change substantially. ChefSpec currently works only with Chef 0.9.12 and has been tested on Ruby 1.8.7. It may make your machine burst into flames or install OS X Lion.

# Quick Start
Given an existing cookbook directory structure, create a new `spec` directory within it to hold your specs.

## Writing a cookbook example

This is a recipe that installs the foo package, and the matching example that expresses that expectation.

### cookbooks/example/recipes/default.rb

    package "foo" do
      action :install
    end

### cookbooks/example/spec/default_spec.rb

    require "chefspec"

    describe "example::default" do
      before(:all) do
        @chef_run = ChefSpec::ChefRunner.new
        @chef_run.converge "example::default"
      end

      it "should install foo" do
        @chef_run.should install_package "foo"
      end
    end

## Setting node attributes

ChefSpec lets you override node attributes (including [OHAI](http://wiki.opscode.com/display/chef/Ohai) attributes) as
you'd expect:

    it "should log the node platform" do
      @chef_run = ChefSpec::ChefRunner.new
      @chef_run.node.foo = "bar"
      @chef_run.converge "example::default"
      @chef_run.should log "The value of node.foo is: bar"
    end

# Matchers

You can use RSpec `should` and `should_not` to define the expected outcome of applying your recipe using the following
matchers:

## Files and Directories

Matchers for the Chef [File](http://wiki.opscode.com/display/chef/Resources#Resources-File) and [Directory](http://wiki.opscode.com/display/chef/Resources#Resources-Directory) resources.

### create_file

    @chef_run.should create_file "/var/log/bar.log"

### delete_file

    @chef_run.should delete_file "/var/log/bar.log"

### create_directory

    @chef_run.should create_directory "/var/lib/foo"

### delete_directory

    @chef_run.should delete_directory "/var/lib/foo"

### be_owned_by

    @chef_run.file("/var/log/bar.log").should be_owned_by("user", "group")
    @chef_run.directory("/var/lib/foo").should be_owned_by("user", "group")

## Packages
Matchers for the Chef [Package](http://wiki.opscode.com/display/chef/Resources#Resources-Package) resource.

### install_package

    @chef_run.should install_package "foo"
    @chef_run.should install_package_at_version "foo", "1.2.3"

### purge_package

    @chef_run.should purge_package "foo"

### remove_package

    @chef_run.should remove_package "foo"


### upgrade_package

    @chef_run.should upgrade_package "foo"

## Execute
Matcher for the Chef [Execute](http://wiki.opscode.com/display/chef/Resources#Resources-Execute) resource.

### execute_command

    @chef_run.should execute_command "whoami"

## Logging
Matcher for the Chef [Log](http://wiki.opscode.com/display/chef/Resources#Resources-Log) resource.

### log

    @chef_run.should log "A log message from my recipe"

## Services
Matchers for the Chef [Service](http://wiki.opscode.com/display/chef/Resources#Resources-Service) resource.

### start_service

    @chef_run.should start_service "food"

### set_service_to_start_on_boot

    @chef_run.should set_service_to_start_on_boot "food"

### stop_service

    @chef_run.should stop_service "food"

### restart_service

    @chef_run.should restart_service "food"

### reload_service

    @chef_run.should reload_service "food"

# More Examples

There are further examples of using ChefSpec in the `features` directory.

# Building

    $ bundle install
    $ rake

# License
MIT - see the accompanying LICENSE file for details.

# Contributing
Additional matchers and bugfixes are welcome! Please fork and submit a pull request on an individual branch per change.
Feature: Cookbook with library which installs gem

  Chefspec should allow library to install gem and use other resources. 
  Library is required by chef before the node's runner is created therefore 
  Chefspec should fall back to default resource's run_action implementation.

  Background:
    * I am using the "library_gem" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

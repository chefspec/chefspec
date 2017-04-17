Feature: Testing an LWRP with inline resources
  Background:
    * I am using the "custom_resource" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

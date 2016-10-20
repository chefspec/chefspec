Feature: Overriding attributes in the Runner
  Background:
    * I am using the "attributes" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

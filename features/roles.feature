Feature: Overriding roles in the Runner
  Background:
    * I am using the "roles" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

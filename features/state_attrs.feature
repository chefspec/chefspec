Feature: Testing state attributes
  Background:
    * I am using the "state_attrs" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

Feature: The multiple_actions matcher
  Background:
    * I am using the "multiple_actions" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

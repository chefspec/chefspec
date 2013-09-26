Feature: The multiple_run_action matcher
  Background:
    * I am using the "multiple_run_action" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

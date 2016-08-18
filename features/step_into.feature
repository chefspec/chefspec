Feature: The step_into matcher
  Background:
    * I am using the "step_into" cookbook

  Scenario:
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

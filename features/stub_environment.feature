Feature: The stub_environment matcher
  Background:
    * I am using the "stub_environment" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

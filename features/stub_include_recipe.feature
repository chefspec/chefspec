Feature: The stub_include_recipe matcher
  Background:
    * I am using the "stub_include_recipe" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

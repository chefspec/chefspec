Feature: The stub_node matcher
  Background:
    * I am using the "stub_node" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

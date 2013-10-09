Feature: The stub_search matcher
  Background:
    * I am using the "stub_search" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

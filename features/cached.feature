Feature: The cached runner
  Background:
    * I am using the "cached" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

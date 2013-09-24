Feature: The inherits matcher
  Background:
    * I am using the "inherits" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

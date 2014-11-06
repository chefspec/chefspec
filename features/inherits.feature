@not_chef_12_0_0_rc_0
Feature: The inherits matcher
  Background:
    * I am using the "inherits" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

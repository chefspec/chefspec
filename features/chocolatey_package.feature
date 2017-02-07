@not_chef_12_6_0

Feature: The chocolatey_package matcher
  Background:
    * I am using the "chocolatey_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | install |
    | remove  |
    | upgrade |

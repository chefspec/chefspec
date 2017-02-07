@not_chef_12_6_0

Feature: The osx_profile matcher
  Background:
    * I am using the "osx_profile" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | install  |
    | remove   |

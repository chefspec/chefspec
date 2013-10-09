Feature: The directory matcher
  Background:
    * I am using the "directory" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | create  |
    | delete  |

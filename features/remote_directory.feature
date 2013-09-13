Feature: The remote_directory matcher
  Background:
    * I am using the "remote_directory" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher           |
    | create            |
    | create_if_missing |
    | delete            |

Feature: The file matcher
  Background:
    * I am using the "file" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher           |
    | create            |
    | create_if_missing |
    | delete            |
    | touch             |

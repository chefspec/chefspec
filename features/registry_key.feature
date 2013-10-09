Feature: The registry_key matcher
  Background:
    * I am using the "registry_key" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher            |
    | create             |
    | create_if_missing  |
    | delete             |
    | delete_key         |

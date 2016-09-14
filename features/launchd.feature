Feature: The launchd matcher
  Background:
    * I am using the "launchd" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher          |
    | create           |
    | creat_if_missing |
    | delete           |
    | disable          |
    | enable           |

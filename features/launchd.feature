@not_chef_12_6_0
@not_chef_12_7_2

Feature: The launchd matcher
  Background:
    * I am using the "launchd" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher           |
    | create            |
    | create_if_missing |
    | delete            |
    | disable           |
    | enable            |

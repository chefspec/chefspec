@not_chef_12_6_0

Feature: The apt_update matcher
  Background:
    * I am using the "apt_update" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | periodic |
    | update   |

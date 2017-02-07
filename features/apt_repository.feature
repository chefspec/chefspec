@not_chef_12_6_0
@not_chef_12_7_2
@not_chef_12_8_1

Feature: The apt_repository matcher
  Background:
    * I am using the "apt_repository" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | add     |
    | remove  |

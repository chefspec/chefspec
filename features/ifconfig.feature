Feature: The ifconfig matcher
  Background:
    * I am using the "ifconfig" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | add     |
    | delete  |
    | disable |
    | enable  |

Feature: The route matcher
  Background:
    * I am using the "route" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | add     |
    | delete  |

Feature: The do_nothing matcher
  Background:
    * I am using the "do_nothing" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | default |

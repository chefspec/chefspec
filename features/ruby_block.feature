Feature: The ruby_block matcher
  Background:
    * I am using the "ruby_block" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | run     |
    | create  |

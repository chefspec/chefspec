Feature: The scm matcher
  Background:
    * I am using the "scm" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher      |
    | checkout     |
    | export       |
    | sync         |

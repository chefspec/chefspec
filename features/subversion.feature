Feature: The subversion matcher
  Background:
    * I am using the "subversion" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher      |
    | checkout     |
    | export       |
    | force_export |
    | sync         |

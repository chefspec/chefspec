Feature: The guards matcher
  Background:
    * I am using the "guards" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher     |
    | default     |

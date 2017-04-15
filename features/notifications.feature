Feature: The notifications matcher
  Background:
    * I am using the "notifications" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher     |
    | before      |
    | chained     |
    | default     |
    | delayed     |
    | immediately |
    | guard       |

Feature: The http_request matcher
  Background:
    * I am using the "http_request" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | delete  |
    | head    |
    | get     |
    | options |
    | post    |
    | put     |

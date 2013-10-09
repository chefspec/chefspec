Feature: The service matcher
  Background:
    * I am using the "service" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | disable |
    | enable  |
    | reload  |
    | restart |
    | start   |
    | stop    |

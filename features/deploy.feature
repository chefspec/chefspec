Feature: The deploy matcher
  Background:
    * I am using the "deploy" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher      |
    | deploy       |
    | force_deploy |
    | rollback     |

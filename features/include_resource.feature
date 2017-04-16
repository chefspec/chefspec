Feature: The include_resource matcher
  Background:
    * I am using the "include_resource" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | default |

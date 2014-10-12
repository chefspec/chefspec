Feature: The powershell_script matcher
  Background:
    * I am using the "powershell_script" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | run     |

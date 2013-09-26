Feature: The expect_exception matcher
  Background:
    * I am using the "expect_exception" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher        |
    | compile_error  |
    | converge_error |
    | no_error       |

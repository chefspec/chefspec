@not_chef_12_0_3

Feature: The openbsd_package matcher
  Background:
    * I am using the "openbsd_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | install  |
    | purge    |
    | remove   |

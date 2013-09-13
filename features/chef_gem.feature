Feature: The chef_gem matcher
  Background:
    * I am using the "chef_gem" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | install  |
    | purge    |
    | reconfig |
    | remove   |
    | upgrade  |

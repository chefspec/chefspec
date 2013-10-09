@not_chef_11_0_0
@not_chef_11_2_0
@not_chef_11_4_4
@not_chef_11_6_0
Feature: The solaris_package matcher
  Background:
    * I am using the "solaris_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | install  |
    | remove   |

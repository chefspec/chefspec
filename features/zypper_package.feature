@not_chef_12_0_3
@not_chef_12_1_2
@not_chef_12_2_1
@not_chef_12_3_0

Feature: The zypper_package matcher
  Background:
    * I am using the "zypper_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | install  |
    | purge    |
    | remove   |
    | upgrade  |

@not_chef_12_6_0
@not_chef_12_7_2
@not_chef_12_8_1
@not_chef_12_9_41
@not_chef_12_10_24
@not_chef_12_11_18
@not_chef_12_12_15
@not_chef_12_13_37
@not_chef_12_14_89

Feature: The cab_package matcher
  Background:
    * I am using the "cab_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher  |
    | install  |
    | remove   |

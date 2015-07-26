@not_chef_11_14_2
@not_chef_11_14_6
@not_chef_11_16_0
@not_chef_11_16_2
@not_chef_11_16_4
@not_chef_11_18_0
@not_chef_11_18_6
@not_chef_12_0_3
@not_chef_12_1_0
@not_chef_12_1_1
@not_chef_12_1_2
@not_chef_12_2_1
@not_chef_12_3_0
Feature: The windows_package matcher
  Background:
    * I am using the "windows_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | install |
    | remove  |

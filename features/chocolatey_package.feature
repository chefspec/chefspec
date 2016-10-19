@not_chef_12_0_3
@not_chef_12_1_2
@not_chef_12_2_1
@not_chef_12_3_0
@not_chef_12_4_3
@not_chef_12_5_1
@not_chef_12_6_0

Feature: The chocolatey_package matcher
  Background:
    * I am using the "chocolatey_package" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | install |
    | remove  |
    | upgrade |

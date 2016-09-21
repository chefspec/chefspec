@not_chef_12_0_3
@not_chef_12_1_2
@not_chef_12_2_1
@not_chef_12_3_0
@not_chef_12_4_3
@not_chef_12_5_1
@not_chef_12_6_0
@not_chef_12_7_2
@not_chef_12_8_1
@not_chef_12_9_41
@not_chef_12_10_24
@not_chef_12_11_18
@not_chef_12_12_15
@not_chef_12_13_37

Feature: The yum_repository matcher
  Background:
    * I am using the "yum_repository" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher    |
    | create     |
    | delete     |
    | add        |
    | remove     |
    | makecache  |

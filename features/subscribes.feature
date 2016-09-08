@not_chef_12_0_3
@not_chef_12_1_2
@not_chef_12_2_1
@not_chef_12_3_0
@not_chef_12_4_3
@not_chef_12_5_1

Feature: The subscribes matcher
  Background:
    * I am using the "subscribes" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher     |
    | before      |
    | chained     |
    | default     |
    | delayed     |
    | immediately |

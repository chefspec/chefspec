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

Feature: The systemd_unit matcher
  Background:
    * I am using the "systemd_unit" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher               |
    | create                |
    | delete                |
    | enable                |
    | disable               |
    | mask                  |
    | unmask                |
    | start                 |
    | stop                  |
    | restart               |
    | try_restart           |
    | reload_or_restart     |
    | reload_or_try_restart |

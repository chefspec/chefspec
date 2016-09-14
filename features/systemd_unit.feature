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

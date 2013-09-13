Feature: The mount matcher
  Background:
    * I am using the "mount" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | disable |
    | enable  |
    | mount   |
    | remount |
    | umount  |

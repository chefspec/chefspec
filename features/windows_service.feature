@not_chef_11_14_2
@not_chef_11_14_6
@not_chef_11_16_0
@not_chef_11_16_2
@not_chef_11_16_4
@not_chef_11_18_0
@not_chef_11_18_6
Feature: The windows_service matcher
  Background:
    * I am using the "windows_service" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | configure_startup |
    | disable |
    | enable  |
    | reload  |
    | restart |
    | start   |
    | stop    |

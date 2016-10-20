@not_chef_12_0_3
@not_chef_12_1_2

Feature: The dsc_resource matcher
  Background:
    * I am using the "dsc_resource" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
    Examples:
      | Matcher |
      | run     |

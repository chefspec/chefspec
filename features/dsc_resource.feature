@not_chef_12_0_3
@not_chef_12_1_0
@not_chef_12_1_1
@not_chef_12_1_2
Feature: The dsc_resource matcher
  Background:
    * I am using the "dsc_resource" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

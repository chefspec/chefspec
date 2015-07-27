@not_chef_11_14_2
@not_chef_11_14_6
@not_chef_11_16_0
@not_chef_11_16_2
@not_chef_11_16_4
@not_chef_11_18_0
@not_chef_11_18_6
Feature: The step_into matcher
  Background:
    * I am using the "step_into" cookbook

  Scenario:
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

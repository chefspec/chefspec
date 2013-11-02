@not_chef_11_0_0
@not_chef_11_2_0
@not_chef_11_4_4
@not_chef_11_6_0
Feature: Testing state attributes
  Background:
    * I am using the "state_attrs" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

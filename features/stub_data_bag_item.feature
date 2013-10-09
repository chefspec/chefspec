Feature: The stub_data_bag_item matcher
  Background:
    * I am using the "stub_data_bag_item" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

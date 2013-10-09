Feature: The stub_data_bag matcher
  Background:
    * I am using the "stub_data_bag" cookbook

  Scenario: Running specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

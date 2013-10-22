Feature: Testing an LWRP with inline resources
  Background:
    * I am using the "use_inline_resources" cookbook

  Scenario: Running the specs
    * I successfully run `rspec spec/default_spec.rb`
    * the output should contain "0 failures"

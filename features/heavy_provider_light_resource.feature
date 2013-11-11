Feature: A cookbook with a heavy provider and light weight resource
  Background:
    * I am using the "heavy_provider_light_resource" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher          |
    | provider_service |

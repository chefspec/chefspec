Feature: The ChefSpec server
  Background:
    * I am using the "server" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Component>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Component          |
    | client             |
    | data_bag           |
    | environment        |
    | node               |
    | render_with_cached |
    | role               |
    | search             |

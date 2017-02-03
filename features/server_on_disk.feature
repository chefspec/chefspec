Feature: The ChefSpec server with on-disk storage
  Background:
    * I am using the "server" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Component>_spec.rb --require ../../../features/support/on_disk.rb`
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

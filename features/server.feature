# We need to spawn a new process because requiring the server module changes
# the default behavior of ChefSpec. Additionally, there's a bug in ChefZero
# that doesn't work with Chef Chef 11.0.0 and 11.2.0.
@spawn
@not_chef_11_0_0
@not_chef_11_2_0
Feature: The ChefSpec server
  Background:
    * I am using the "server" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Compontent>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Compontent  |
    | client      |
    | data_bag    |
    | environment |
    | node        |
    | role        |
    | search      |

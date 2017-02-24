Feature: The ChefSpec server with exotic port
  Background:
    * I am using the "server" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/exotic_port_spec.rb --require ../../../features/support/exotic_zero_port.rb`
    * the output should contain "0 failures"

@not_implemented_minitest
Feature: Write examples for LWRP

  ChefSpec by default overrides resources to have no action. This means that the code inside
  your LWRP's will never be executed.

  In order to allow your LWRP to be run, you have to explicitly tell ChefRunner to step into it:

    runner = ChefSpec::ChefRunner.new(:step_into => ['example'])

  Scenario: Write example for LWRP
    Given a Chef cookbook with a LWRP and a recipe that declares it
    And the recipe has a spec example that expects the LWRP to be run
    When the recipe example is successfully run
    Then the LWRP will have been executed

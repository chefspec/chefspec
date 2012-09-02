Feature: Write examples for LWRP

  ChefSpec lets you write examples for LWRP's!

  @not_implemented_minitest
  Scenario: Example LWRP
    Given a Chef cookbook with a LWRP and a recipe that declares it
    And the recipe has a spec example that expects the lwrp to be run
    When the recipe example is successfully run
    Then the lwrp will have been executed

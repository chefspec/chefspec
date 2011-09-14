Feature: Write examples for executing commands

  In order to receive fast feedback when developing recipes
  As a developer
  I want to be able to test execute resources without actually converging a node

  Scenario: Execute resource
    Given a Chef cookbook with a recipe that declares an execute resource
    And the recipe has a spec example that expects the command to be executed
    When the recipe example is successfully run
    Then the command will not have been executed
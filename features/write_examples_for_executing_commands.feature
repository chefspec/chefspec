@not_implemented_minitest
Feature: Write examples for executing commands

      chef_run.should execute_command "whoami"

  Scenario: Execute resource
    Given a Chef cookbook with a recipe that declares an execute resource
    And the recipe has a spec example that expects the command to be executed
    When the recipe example is successfully run
    Then the command will not have been executed

  Scenario: Use convenience method for execute resource
    Given a Chef cookbook with a recipe that declares an execute resource
    And the recipe has a spec example that uses the convenience method to access the execute resource
    When the recipe example is successfully run
    Then the command will not have been executed

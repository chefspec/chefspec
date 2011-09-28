Feature: Generate placeholder examples

  In order to encourage cookbooks to have examples
  As a developer
  I want to generate placeholder examples

  Scenario: List cookbook creation options
    Given a workstation with a Chef admin client
     When I view the cookbook commands
     Then a command will exist to specify that a placeholder example should be generated

  Scenario: Create new cookbook with default options
    Given a workstation with a Chef admin client
     When I issue the command to create a new cookbook
     Then the cookbook will be created
      But no placeholder example will be generated
      And no examples will be found to run

  Scenario: Create new cookbook with example
    Given a workstation with a Chef admin client
     When I issue the command to create a new cookbook specifying that an example should be generated
     Then a placeholder example will be generated to describe the generated default recipe
      And the example when run will be pending


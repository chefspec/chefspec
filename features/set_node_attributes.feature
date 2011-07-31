Feature: Set node attributes

  In order to have examples that thoroughly exercise my recipes
  As a developer
  I want to be able to set all node attributes within the example (including automatic)

  Scenario: Set node attribute
    Given a Chef cookbook with a recipe that logs a node attribute
    And the recipe has a spec example that sets a node attribute
    When the recipe example is successfully run
    Then the recipe will see the node attribute set in the spec example

  Scenario: Override automatic attributes
    Given a Chef cookbook with a recipe that has conditional execution based on operating system
    And the recipe has a spec example that overrides the operating system to 'leprechaun'
    When the recipe example is successfully run
    Then the resources declared for the operating system will be available within the example

Feature: Write examples for templates

  In order to receive fast feedback when developing recipes
  As a developer
  I want to be able to test template resources without actually converging a node

  Scenario: Template resource
    Given a Chef cookbook with a recipe that declares a template resource
    And the recipe has a spec example that expects the template to be rendered
    When the recipe example is successfully run
    Then the file will not have been created

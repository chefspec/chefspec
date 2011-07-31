Feature: Write examples for files

  In order to receive fast feedback when developing recipes
  As a developer
  I want to be able to test file resources without actually converging a node

  Scenario: File resource
    Given a Chef cookbook with a recipe that declares a file resource
    And the recipe has a spec example that expects the file to be declared
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Delete a file
    Given a Chef cookbook with a recipe that deletes a file
    And the recipe has a spec example that expects the file to be deleted
    When the recipe example is successfully run
    Then the file will not have been deleted

  Scenario: Create a directory
    Given a Chef cookbook with a recipe that creates a directory
    And the recipe has a spec example that expects the directory to be created
    When the recipe example is successfully run
    Then the directory will not have been created

  Scenario: Delete a directory
    Given a Chef cookbook with a recipe that deletes a directory
    And the recipe has a spec example that expects the directory to be deleted
    When the recipe example is successfully run
    Then the directory will not have been deleted

  Scenario: Check file ownership
    Given a Chef cookbook with a recipe that sets file ownership
    And the recipe has a spec example that expects the file to be set to be owned by a specific user
    When the recipe example is successfully run
    Then the file will not have had its ownership changed

  Scenario: Check directory ownership
    Given a Chef cookbook with a recipe that sets directory ownership
    And the recipe has a spec example that expects the directory to be set to be owned by a specific user
    When the recipe example is successfully run
    Then the directory will not have had its ownership changed


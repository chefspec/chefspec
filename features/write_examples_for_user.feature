Feature: Write examples for cookbook users

  ChefSpec lets you express expectations about users created by your recipes.

  Check that a user has been created:

      chef_run.should create_user 'foo'

  Scenario: Create a user
    Given a Chef cookbook with a recipe that creates a user resource
    And the recipe has a spec example that expects the user to be created
    When the recipe example is successfully run
    Then the user will not have been created

  Scenario: Remove a user
    Given a Chef cookbook with a recipe that removes a user resource
    And the recipe has a spec example that expects the user to be removed
    When the recipe example is successfully run
    Then the user will not have been created

  Scenario: Use the user convenience method to access the user resource
    Given a Chef cookbook with a recipe that creates a user resource
    And the recipe has a spec example that uses the convenience method to access the user resource
    When the recipe example is successfully run
    Then the user will not have been created


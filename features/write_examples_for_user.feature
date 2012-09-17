Feature: Write examples for cookbook users

  ChefSpec lets you express expectations about users created by your recipes.

  Check that a user has been created:

      chef_run.should create_user 'foo'

  Scenario: Create an user
    Given a Chef cookbook with a recipe that creates an user resource
    And the recipe has a spec example that expects the user to be declared
    When the recipe example is successfully run
    Then the user will not have been created


Feature: Write examples for cookbook groups

  ChefSpec lets you express expectations about groups created by your recipes.

  Check that a group has been created:

      expect(chef_run).to create_group('foo')

  Scenario: Create a group
    Given a Chef cookbook with a recipe that creates a group resource
    And the recipe has a spec example that expects the group to be created
    When the recipe example is successfully run
    Then the group will not have been created

  Scenario: Remove a group
    Given a Chef cookbook with a recipe that removes a group resource
    And the recipe has a spec example that expects the group to be removed
    When the recipe example is successfully run
    Then the group will not have been created

  Scenario: Use the group convenience method to access the group resource
    Given a Chef cookbook with a recipe that creates a group resource
    And the recipe has a spec example that uses the convenience method to access the group resource
    When the recipe example is successfully run
    Then the group will not have been created


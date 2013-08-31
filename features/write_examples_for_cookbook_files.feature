Feature: Write examples for cookbook files

  ChefSpec lets you express expectations about cookbook files created by your recipes.

  Check that a cookbook file has been created:

      expect(chef_run).to create_file('/var/lib/foo')

  Check that a file has the correct ownership:

      expect(chef_run.cookbook_file('/var/log/bar.log')).to be_owned_by('user', 'group')

  Scenario: Cookbook file resource
    Given a Chef cookbook with a recipe that declares a cookbook file resource
    And the recipe has a spec example that expects the cookbook file to be declared
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Cookbook file resource content
    Given a Chef cookbook with a recipe that declares a cookbook file resource
    And the recipe has a spec example of the cookbook file contents
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Check cookbook file ownership
    Given a Chef cookbook with a recipe that sets cookbook file ownership
    And the recipe has a spec example that expects the cookbook file to be set to be owned by a specific user
    When the recipe example is successfully run
    Then the file will not have had its ownership changed

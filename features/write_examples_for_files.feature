Feature: Write examples for files

  ChefSpec lets you express expectations about files and directories created by your recipes. This won't work for files
  or directories that are not explicitly declared in the recipe, for example directories created by the installation of
  a new package.

  Check that a directory has been created:

      expect(chef_run).to create_directory '/var/lib/foo'

  Check that a file has the correct ownership:

      expect(chef_run.file('/var/log/bar.log')).to be_owned_by('user', 'group')

  Scenario: File resource
    Given a Chef cookbook with a recipe that declares a file resource
    And the recipe has a spec example that expects the file to be declared
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: File resource content
    Given a Chef cookbook with a recipe that declares a file resource and sets the contents
    And the recipe has a spec example of the file contents
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

  Scenario: Create a remote file
    Given a Chef cookbook with a recipe that creates a remote file
    And the recipe has a spec example that expects the remote file to be created
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Create a remote file only if the file is missing
    Given a Chef cookbook with a recipe that creates a missing remote file
    And the recipe has a spec example that expects the missing remote file to be created
    When the recipe example is successfully run
    Then the file will not have been created

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


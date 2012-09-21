@not_implemented_minitest
Feature: Write examples for env

  ChefSpec lets you express expectations about environment create by your recipes.
  
  Check that environment variable has been set
    chef_run.shoule create_env 'JAVA_HOME' ,'/foo/bar' 

Scenario: Create an environment variable
  Given a Chef cookbook with a recipe that creates an environment variable
  And the recipe has a spec example that expects the env to be created
  When the recipe example is successfully run
  Then the environment variable should not be created

Scenario: modify an environment variable
  Given a Chef cookbook with a recipe that modifies an environment variable
  And the recipe has a spec example that expects the env to be modified
  When the recipe example is successfully run
  Then the environment variable should not be modified

Scenario: Delete an environment variable
  Given a Chef cookbook with a recipe that deletes an environment variable
  And the recipe has a spec example that expects the env to be deleted
  When the recipe example is successfully run
  Then the environment variable should not be deleted


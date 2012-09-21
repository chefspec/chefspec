@not_implemented_minitest
Feature: Write examples for include_recipe

  ChefSpec lets you express expectations about include_recipe
  statements within your recipe

  Check that recipe is being included:

    chef_run.should include_recipe 'foo::bar'

  Scenario: Include recipe
    Given a Chef cookbook with a recipe that includes another recipe
    And the main recipe has a spec example that expects the other recipe to be included
    When the recipe example is successfully run
    Then the dependency recipe will be converged too

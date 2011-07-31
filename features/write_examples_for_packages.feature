Feature: Write examples for packages

  In order to receive fast feedback when developing recipes
  As a developer
  I want to be able to test package resources without actually converging a node

  Scenario: Package resource
    Given a Chef cookbook with a recipe that declares a package resource
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Package resource with fixed version
    Given a Chef cookbook with a recipe that declares a package resource at a fixed version
    And the recipe has a spec example that expects the package to be installed at that version
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Upgrade a package
    Given a Chef cookbook with a recipe that upgrades a package
    And the recipe has a spec example that expects the package to be upgraded
    When the recipe example is successfully run
    Then the package will not have been upgraded

  Scenario: Remove a package
    Given a Chef cookbook with a recipe that removes a package
    And the recipe has a spec example that expects the package to be removed
    When the recipe example is successfully run
    Then the package will not have been removed

  Scenario: Purge a package
    Given a Chef cookbook with a recipe that purges a package
    And the recipe has a spec example that expects the package to be purged
    When the recipe example is successfully run
    Then the package will not have been purged

  Scenario: Execute resource
    Given a Chef cookbook with a recipe that declares an execute resource
    And the recipe has a spec example that expects the command to be executed
    When the recipe example is successfully run
    Then the command will not have been executed

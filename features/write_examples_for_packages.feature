Feature: Write examples for packages

  Express an expectation that a package will be installed:

      chef_run.should install_package 'foo'

  Scenario: Package resource
    Given a Chef cookbook with a recipe that declares a package resource
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Package resource with default action
    Given a Chef cookbook with a recipe that declares a package resource with no action specified
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Package resource with fixed version
    Given a Chef cookbook with a recipe that declares a package resource at a fixed version
    And the recipe has a spec example that expects the package to be installed at that version
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Package resource with fixed version and default action
    Given a Chef cookbook with a recipe that declares a package resource at a fixed version with no action specified
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

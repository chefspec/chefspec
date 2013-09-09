Feature: Write examples for yum packages

  Express an expectation that a package will be installed:

      expect(chef_run).to install_yum_package('foo')

  Scenario: Yum package resource
    Given a Chef cookbook with a recipe that declares a yum_package resource
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Yum package resource with default action
    Given a Chef cookbook with a recipe that declares a yum_package resource with no action specified
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Yum package resource with fixed version
    Given a Chef cookbook with a recipe that declares a yum_package resource at a fixed version
    And the recipe has a spec example that expects the package to be installed at that version
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Yum package resource with fixed version and default action
    Given a Chef cookbook with a recipe that declares a yum_package resource at a fixed version with no action specified
    And the recipe has a spec example that expects the package to be installed at that version
    When the recipe example is successfully run
    Then the package will not have been installed

  @not_implemented_minitest
  Scenario: Upgrade a package
    Given a Chef cookbook that uses yum_package to upgrade a package
    And the recipe has a spec example that expects the package to be upgraded
    When the recipe example is successfully run
    Then the package will not have been upgraded

  Scenario: Remove a package
    Given a Chef cookbook that uses yum_package to remove a package
    And the recipe has a spec example that expects the package to be removed
    When the recipe example is successfully run
    Then the package will not have been removed

  Scenario: Purge a package
    Given a Chef cookbook that uses yum_package to purge a package
    And the recipe has a spec example that expects the package to be purged
    When the recipe example is successfully run
    Then the package will not have been purged

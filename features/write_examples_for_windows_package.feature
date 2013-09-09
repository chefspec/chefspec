Feature: Write examples for yum packages

  Express an expectation that a package will be installed:

      chef_run.should install_windows_package 'foo'

  Scenario: Windows package resource
    Given a Chef cookbook with a recipe that declares a windows_package resource
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Windows package resource with default action
    Given a Chef cookbook with a recipe that declares a windows_package resource with no action specified
    And the recipe has a spec example that expects the package to be installed
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Windows package resource with fixed version
    Given a Chef cookbook with a recipe that declares a windows_package resource at a fixed version
    And the recipe has a spec example that expects the package to be installed at that version
    When the recipe example is successfully run
    Then the package will not have been installed

  Scenario: Windows package resource with fixed version and default action
    Given a Chef cookbook with a recipe that declares a windows_package resource at a fixed version with no action specified
    And the recipe has a spec example that expects the package to be installed at that version
    When the recipe example is successfully run
    Then the package will not have been installed

  @not_implemented_minitest
  Scenario: Remove a package
    Given a Chef cookbook that uses windows_package to remove a package 
    And the recipe has a spec example that expects the package to be removed
    When the recipe example is successfully run
    Then the package will not have been removed

Feature: Write examples for services

  In order to receive fast feedback when developing recipes
  As a developer
  I want to be able to test service resources without actually converging a node

  Scenario: Start a service
    Given a Chef cookbook with a recipe that starts a service
    And the recipe has a spec example that expects the service to be started
    When the recipe example is successfully run
    Then the service will not have been started

  Scenario: Start a service and configure to start at boot
    Given a Chef cookbook with a recipe that starts a service and enables it to start on boot
    And the recipe has a spec example that expects the service to be started and enabled
    When the recipe example is successfully run
    Then the service will not have been started

  Scenario: Stop a service
    Given a Chef cookbook with a recipe that stops a service
    And the recipe has a spec example that expects the service to be stopped
    When the recipe example is successfully run
    Then the service will not have been stopped

  Scenario: Restart a service
    Given a Chef cookbook with a recipe that restarts a service
    And the recipe has a spec example that expects the service to be restarted
    When the recipe example is successfully run
    Then the service will not have been restarted

  Scenario: Reload a service
    Given a Chef cookbook with a recipe that signals a service to reload
    And the recipe has a spec example that expects the service to be reloaded
    When the recipe example is successfully run
    Then the service will not have been reloaded

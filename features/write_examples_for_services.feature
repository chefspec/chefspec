Feature: Write examples for services

  Services may be created by OS packages, but this matcher only knows about services declared explicitly within your
  Chef recipe.

  Express an expectation that a service will be started:

      expect(chef_run_.to start_service('food')

  Will it come up if we bounce the box?

      expect(chef_run_.to set_service_to_start_on_boot('food')

  Many daemons need a prompt to reload their config and you should check for this:

      expect(chef_run_.to reload_service('food')

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

  Scenario: Restart a service and check for should_not start action
    Given a Chef cookbook with a recipe that restarts a service
    And the recipe has a spec example that expects the service to only have the restart action
    When the recipe example is successfully run
    Then the service will not have been restarted

  Scenario: Reload a service
    Given a Chef cookbook with a recipe that signals a service to reload
    And the recipe has a spec example that expects the service to be reloaded
    When the recipe example is successfully run
    Then the service will not have been reloaded

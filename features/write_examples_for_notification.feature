@not_implemented_minitest
Feature: Write examples for notifcations

  ChefSpec lets you express expectations about one resource
  notifying another upon change.

  Check that a resource is being notified from another resource

      expect(chef_run.template('/etc/nginx/nginx.conf')).to notify('service[nginx]', :restart)

  Scenario: Notify a resource
    Given a Chef cookbook with a recipe in which a template notifies a service
    And the recipe has a spec example that assert on the notification
    When the recipe example is successfully run
    Then the notify assertion will be succesfully evaluated

  Scenario: Notify a resource having square braces in its name
    Given a Chef cookbook with a recipe in which a template notifies a service having braces in its name
    And the recipe has a spec example that assert on the notification service having braces in its name
    When the recipe example is successfully run
    Then the notify assertion will be succesfully evaluated

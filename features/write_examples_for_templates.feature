Feature: Write examples for templates

  Very handy for verifying that the result of rendering a template to generate a config file is what you expect:

      expect(chef_run).to create_file_with_content('/etc/foo', expected_content)

  Scenario: Template resource
    Given a Chef cookbook with a recipe that declares a template resource
    And the recipe has a spec example that expects the template to be rendered
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Rendered template
    Given a Chef cookbook with a recipe that declares a template resource
    And the recipe has a spec example of the rendered template
    When the recipe example is successfully run
    Then the file will not have been created

  @chef_11
  Scenario: Rendered template with partial
    Given a Chef cookbook with a recipe that declares a template resource with partials in it
    And the recipe has a spec example of the rendered template which includes the partial
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Rendered template (from other cookbook)
    Given a Chef cookbook with a recipe that declares a template resource with the template from another cookbook
    And the recipe has a spec example of the rendered template
    When the recipe example is successfully run
    Then the file will not have been created

  Scenario: Missing template
    Given a Chef cookbook with a recipe that declares a missing template resource
    And the recipe has a spec example of the rendered template
    When the recipe example is unsuccessfully run
    Then the file will not have been created

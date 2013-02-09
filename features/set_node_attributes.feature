@not_implemented_minitest
Feature: Set node attributes

  Chef recipes often need to behave differently depending on the attributes of the node they are executing on:

  * The resources that are declared may take different actions based on the value of attributes set.
  * The same recipe may be written to run on multiple operating systems - for example both Ubuntu and CentOS.

  ChefSpec is very handy for running examples of different node attributes against your recipes to validate their
  behaviour quickly. This is without the need for an actual converge which otherwise makes observing behaviour against
  a wide range of attribute values prohibitively slow.

      runner = ChefSpec::ChefRunner.new do |node|
        node.set['my_attribute'] = 'bar'
        node.set['my_other_attribute'] = 'bar2'
      end

  Scenario: Set node attribute
    Given a Chef cookbook with a recipe that logs a node attribute
    And the recipe has a spec example that sets a node attribute
    When the recipe example is successfully run
    Then the recipe will see the node attribute set in the spec example

  Scenario: Override automatic attributes
    Given a Chef cookbook with a recipe that has conditional execution based on operating system
    And the recipe has a spec example that overrides the operating system to 'leprechaun'
    When the recipe example is successfully run
    Then the resources declared for the operating system will be available within the example

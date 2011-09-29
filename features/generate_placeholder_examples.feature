@requires_chef_10
Feature: Generate placeholder examples

  If you are using Chef 0.10.0 or greater then ChefSpec can generate placeholder RSpec examples for you. Knife will
  automagically detect the ChefSpec Knife Plugin and provide you with the new `create_specs` subcommand.

  You can choose to run this immediately after creating a new cookbook like so:

      knife cookbook create -o . my_new_cookbook
      knife cookbook create_specs -o . my_new_cookbook

  The first command is a Knife built-in and will generate the standard Chef cookbook structure, including a default
  recipe. The second is provided by ChefSpec and will add a `specs` directory and a `default_spec.rb` placeholder.

  You can then run the example using rspec:

      rspec my_new_cookbook

  Scenario: List cookbook creation options
    Given a workstation with a Chef admin client
     When I view the cookbook commands
     Then a command will exist to specify that a placeholder example should be generated

  Scenario: Create new cookbook with default options
    Given a workstation with a Chef admin client
     When I issue the command to create a new cookbook:
     """
      knife cookbook create -o . my_new_cookbook
     """
     Then the cookbook will be created
      But no placeholder example will be generated
      And no examples will be found to run

  Scenario: Create new cookbook with example
    Given a workstation with a Chef admin client
     When I issue the commands to create a new cookbook specifying that an example should be generated:
     """
      knife cookbook create -o . my_new_cookbook
      knife cookbook create_specs -o . my_new_cookbook
     """
     Then a placeholder example will be generated to describe the generated default recipe
      And the example when run will be pending

  Scenario: Attempt generation for a cookbook with existing examples
    Given a workstation with a Chef admin client
      And an existing cookbook with an example
     When I issue the command to generate placeholder examples
     Then the existing example will not be overwritten

  Scenario: Generate examples for existing cookbook
    Given a workstation with a Chef admin client
      And an existing cookbook with four recipes but no examples
     When I issue the command to generate placeholder examples
     Then a placeholder example will be generated for each recipe

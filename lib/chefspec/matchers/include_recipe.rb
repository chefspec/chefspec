module ChefSpec
  module Matchers
    #
    # Assert that a Chef run includes a certain recipe.
    #
    # @example Assert the apache2::default recipe is included in the Chef run
    #   expect(chef_run).to include_recipe('apache2::default')
    #
    #
    # NOTE: This matches the literal name of the recipe in the resource
    # collection. This means if you `include_recipe 'apache2'`, then
    # the matcher `include_recipe('apache2::default')` will fail. For
    # this reason, it is always recommended you explictly list the name of
    # the recipe, even if it's the default.
    #
    RSpec::Matchers.define(:include_recipe) do |expected_recipe|
      match do |chef_run|
        chef_run.run_context.loaded_recipes.include?(expected_recipe)
      end

      failure_message_for_should do |chef_run|
        "expected #{chef_run.run_context.loaded_recipes.to_s} to include '#{expected_recipe}'"
      end

      failure_message_for_should_not do |chef_run|
        "expected '#{expected_recipe}' to not be included"
      end
    end
  end
end

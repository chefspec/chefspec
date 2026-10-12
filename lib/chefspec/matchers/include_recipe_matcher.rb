module ChefSpec::Matchers
  #
  # Asserts that the Chef run loaded a specific recipe.
  #
  # Built by {ChefSpec::API::IncludeRecipe#include_recipe}. Recipe names are
  # normalized before comparison, so +"nginx"+ and +"nginx::default"+ are
  # treated as the same recipe.
  #
  # @example
  #   expect(chef_run).to include_recipe("nginx::source")
  #
  class IncludeRecipeMatcher
    #
    # Create a new matcher for the given recipe.
    #
    # @param [String] recipe_name
    #   the recipe to look for, with or without an explicit +::default+
    #
    def initialize(recipe_name)
      @recipe_name = with_default(recipe_name)
    end

    #
    # Determine whether the recipe is among those loaded by the Chef run.
    #
    # @param [ChefSpec::SoloRunner, ChefSpec::ServerRunner] runner
    #   the converged runner to inspect
    #
    # @return [true, false]
    #
    def matches?(runner)
      @runner = runner
      loaded_recipes.include?(@recipe_name)
    end

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      %Q{include recipe "#{@recipe_name}"}
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
    def failure_message
      %Q{expected #{loaded_recipes.inspect} to include "#{@recipe_name}"}
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      %Q{expected "#{@recipe_name}" to not be included}
    end

    private

    #
    # Automatically appends "+::default+" to recipes that need them.
    #
    # @param [String] name
    #
    # @return [String]
    #
    def with_default(name)
      name.include?("::") ? name : "#{name}::default"
    end

    #
    # The list of loaded recipes on the Chef run (normalized)
    #
    # @return [Array<String>]
    #
    def loaded_recipes
      @runner.run_context.loaded_recipes.map { |name| with_default(name) }
    end
  end
end

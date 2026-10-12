module ChefSpec::Matchers
  #
  # Asserts that the Chef run included at least one recipe that was not
  # already named in the node's run list.
  #
  # Built by {ChefSpec::API::IncludeAnyRecipe#include_any_recipe}. This is the
  # matcher to reach for when you care that +include_recipe+ was called at all,
  # but not which recipe it pulled in.
  #
  # @example
  #   expect(chef_run).to include_any_recipe
  #
  class IncludeAnyRecipeMatcher
    #
    # Determine whether any recipe was loaded beyond the run list itself.
    #
    # @param [ChefSpec::SoloRunner, ChefSpec::ServerRunner] runner
    #   the converged runner to inspect
    #
    # @return [true, false]
    #
    def matches?(runner)
      @runner = runner
      !(loaded_recipes - run_list_recipes).empty?
    end

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      "include any recipe"
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
    def failure_message
      "expected to include any recipe"
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      "expected not to include any recipes"
    end

    private

    #
    # The list of run_list recipes on the Chef run (normalized)
    #
    # @return [Array<String>]
    #
    def run_list_recipes
      @runner.run_context.node.run_list.run_list_items.map { |x| with_default(x.name) }
    end

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

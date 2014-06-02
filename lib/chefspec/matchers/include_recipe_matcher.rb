module ChefSpec::Matchers
  class IncludeRecipeMatcher
    def initialize(recipe_name)
      @recipe_name = with_default(recipe_name)
    end

    def matches?(runner)
      @runner = runner
      loaded_recipes.include?(@recipe_name)
    end

    def description
      %Q{include recipe "#{@recipe_name}"}
    end

    def failure_message
      %Q{expected #{loaded_recipes.inspect} to include "#{@recipe_name}"}
    end

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
      name.include?('::') ? name : "#{name}::default"
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

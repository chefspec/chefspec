module ChefSpec::Matchers
  class IncludeAnyRecipeMatcher
    def matches?(runner)
      @runner = runner
      !(loaded_recipes - run_list_recipes).empty?
    end

    def description
      'include any recipe'
    end

    def failure_message
      'expected to include any recipe'
    end

    def failure_message_when_negated
      'expected not to include any recipes'
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

module ChefSpec
  module API
    module IncludeAnyRecipe
      #
      # Assert that a Chef run includes any recipe.
      #
      #     include_recipe 'apache2::default'
      #
      # The Examples section demonstrates the different ways to test an
      # +include_any_recipe+ directive with ChefSpec.
      #
      # @example Assert the Chef run did not include any recipes
      #   expect(chef_run).not_to include_any_recipe
      #
      #
      # @return [ChefSpec::Matchers::IncludeAnyRecipeMatcher]
      #
      def include_any_recipe
        ChefSpec::Matchers::IncludeAnyRecipeMatcher.new
      end
      alias_method :include_any_recipes, :include_any_recipe
    end
  end
end

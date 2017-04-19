module ChefSpec::API
  #
  # Assert that a Chef run includes a certain recipe. Given a Chef Recipe
  # that calls +include_recipe+:
  #
  #     include_recipe 'apache2::default'
  #
  # The Examples section demonstrates the different ways to test an
  # +include_recipe+ directive with ChefSpec.
  #
  # @example Assert the +apache2::default+ recipe is included in the Chef run
  #   expect(chef_run).to include_recipe('apache2::default')
  #
  #
  # @param [String] recipe_name
  #   the name of the recipe to be included
  #
  # @return [ChefSpec::Matchers::IncludeRecipeMatcher]
  #
  def include_recipe(recipe_name)
    ChefSpec::Matchers::IncludeRecipeMatcher.new(recipe_name)
  end
end

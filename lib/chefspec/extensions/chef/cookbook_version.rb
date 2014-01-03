class Chef::CookbookVersion

  alias_method :load_recipe_without_inline_recipe, :load_recipe

  def load_recipe(recipe_name, run_context)
    runner = run_context.node.runner
    recipe_body = runner.virtual_recipes["#{name}::#{recipe_name}"]
    if recipe_body
      recipe = Chef::Recipe.new(name, recipe_name, run_context)
      recipe.instance_eval(&recipe_body)
      return recipe
    else
      return load_recipe_without_inline_recipe(recipe_name, run_context)
    end
  end

end

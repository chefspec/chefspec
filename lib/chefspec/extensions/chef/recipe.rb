require 'chef/recipe'

class Chef::Recipe
  def include_recipe(recipe_name)
    stub = ChefSpec::Stubs::IncludeRecipeRegistry.stub_for(recipe_name)

    if stub.nil?
      raise ChefSpec::Error::IncludeRecipeNotStubbed.new(args: [recipe_name])
    end

    cookbook_name, recipe_short_name = Chef::Recipe.parse_recipe_name(recipe_name)

    if run_context.loaded_fully_qualified_recipe?(cookbook_name, recipe_short_name)
      false
    else
      run_context.send(:loaded_recipe, cookbook_name, recipe_short_name)
    end
  end
end

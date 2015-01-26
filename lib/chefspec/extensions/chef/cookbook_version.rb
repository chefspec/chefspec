require 'chef/cookbook_version'

class Chef
  class CookbookVersion
    alias_method :old_load_recipe, :load_recipe

    def load_recipe(recipe_name, run_context)
      stub = (
        ChefSpec::Stubs::IncludeRecipeRegistry.stub_for(name) ||
        ChefSpec::Stubs::IncludeRecipeRegistry.stub_for("#{name}::#{recipe_name}")
      )
      old_load_recipe(recipe_name, run_context) if stub.nil?
    end
  end
end

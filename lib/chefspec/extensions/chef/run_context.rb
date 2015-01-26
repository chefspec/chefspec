# require 'chef/run_context'
# require 'chef/recipe'

# class Chef::RunContext

#   # @see Chef::DSL::DataQuery#search
#   alias_method :old_load_recipe, :load_recipe
#   def load_recipe(recipe_name, current_cookbook: nil)
#     stub = ChefSpec::Stubs::IncludeRecipeRegistry.stub_for(recipe_name)
#     old_load_recipe(recipe_name) if stub.nil?

#     cookbook_name, recipe_short_name = Chef::Recipe.parse_recipe_name(recipe_name)

#     if loaded_fully_qualified_recipe?(cookbook_name, recipe_short_name)
#       false
#     else
#       loaded_recipe(cookbook_name, recipe_short_name)
#     end
#   end
# end

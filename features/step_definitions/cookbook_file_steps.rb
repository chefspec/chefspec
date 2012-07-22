Given 'a Chef cookbook with a recipe that declares a cookbook file resource' do
  recipe_with_cookbook_file
end

Given 'a Chef cookbook with a recipe that sets cookbook file ownership' do
  recipe_sets_file_ownership(:cookbook_file)
end

Given 'the recipe has a spec example that expects the cookbook file to be declared' do
  spec_expects_file(:cookbook_file)
end

Given 'the recipe has a spec example that expects the cookbook file to be set to be owned by a specific user' do
  spec_expects_file_with_ownership(:cookbook_file)
end

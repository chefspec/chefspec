Given /^a Chef cookbook with a recipe that includes another recipe$/ do
  recipe_includes_another_recipe
end
Given /^the main recipe has a spec example that expects the other recipe to be included$/ do
  spec_expects_include_recipe
end
Then /^the dependency recipe will be converged too$/ do
end



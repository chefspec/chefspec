Given 'a Chef cookbook with a recipe that creates an environment variable' do
  recipe_creates_env_with_action(:create)
end
Given 'the recipe has a spec example that expects the env to be created' do
  spec_expects_env_action(:create)
end
Then /^the environment variable should not be created$/ do
end

Given 'a Chef cookbook with a recipe that modifies an environment variable' do
  recipe_creates_env_with_action(:modify)
end
Given 'the recipe has a spec example that expects the env to be modified' do
  spec_expects_env_action(:modify)
end
Then /^the environment variable should not be modified$/ do
end

Given 'a Chef cookbook with a recipe that deletes an environment variable' do
  recipe_creates_env_with_action(:delete)
end
Given 'the recipe has a spec example that expects the env to be deleted' do
  spec_expects_env_action(:delete)
end
Then /^the environment variable should not be deleted$/ do
end

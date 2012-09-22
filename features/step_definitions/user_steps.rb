Given 'a Chef cookbook with a recipe that creates a user resource' do
  recipe_creates_user
end

Given 'a Chef cookbook with a recipe that removes a user resource' do
  recipe_removes_user
end

Given /^the recipe has a spec example that expects the user to be ([a-z]+)d$/ do |action|
  spec_expects_user_action(action.to_sym)
end

Then 'the user will not have been created' do
end

Given /^the recipe has a spec example the access the user resorce using the convenience method$/ do
  spec_uses_user_convenience_method
end

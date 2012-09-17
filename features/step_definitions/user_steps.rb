Given 'a Chef cookbook with a recipe that creates an user resource' do
  recipe_create_user
end

Given 'the recipe has a spec example that expects the user to be declared' do
  spec_expects_user_action(:create)
end

Then /^the user will not have been created$/ do
end


Given 'a Chef cookbook with a recipe that creates a group resource' do
  recipe_creates_group
end

Given 'a Chef cookbook with a recipe that removes a group resource' do
  recipe_removes_group
end

Given /^the recipe has a spec example that expects the group to be ([a-z]+)d$/ do |action|
  spec_expects_group_action(action.to_sym)
end

Given 'the recipe has a spec example that uses the convenience method to access the group resource' do
  spec_uses_group_convenience_method
end

Then 'the group will not have been created' do
end


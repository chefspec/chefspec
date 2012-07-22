Given 'a Chef cookbook with a recipe that logs a node attribute' do
  recipe_logs_node_attribute
end

Given 'the recipe has a spec example that sets a node attribute' do
  spec_sets_node_attribute
end

Given /^the recipe has a spec example that overrides the operating system to '([^']+)'$/ do |operating_system|
  spec_overrides_operating_system(operating_system)
end

When 'the recipe example is successfully run' do
  run_examples_successfully
end

When 'the recipe example is unsuccessfully run' do
  run_examples_unsuccessfully('No such file or directory')
end

Then 'the recipe will see the node attribute set in the spec example' do
  recipe_sees_correct_attribute_value
end

Then 'the resources declared for the operating system will be available within the example' do
  recipe_sees_correct_operating_system
end

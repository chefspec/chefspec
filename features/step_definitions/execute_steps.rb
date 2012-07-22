Given 'a Chef cookbook with a recipe that declares an execute resource' do
  recipe_executes_command
end

Given 'the recipe has a spec example that expects the command to be executed' do
  spec_expects_command
end

Given 'a Chef cookbook with a recipe that has conditional execution based on operating system' do
  recipe_switches_on_operating_system
end

Then 'the command will not have been executed' do
  command_not_executed
end

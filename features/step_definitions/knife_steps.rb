Given 'a workstation with a Chef admin client' do
  ensure_knife_is_present
end

Given 'an existing cookbook with an example' do
  spec_already_exists
end

Given 'an existing cookbook with four recipes but no examples' do
  cookbook_with_four_recipes
end

When 'I view the cookbook commands' do
  knife_cookbook_commands
end

Then 'a command will exist to specify that a placeholder example should be generated' do
  assert_example_generator_command_exists
end

When /^I issue the commands? to create a new cookbook( specifying that an example should be generated)?:$/ do |do_generate,command|
  command.split("\n").each do |cmd|
    run_simple(unescape(cmd))
  end
  spec_generate_examples(:new) if do_generate
end

When 'I issue the command to generate placeholder examples' do
  spec_generate_examples(:existing)
end

Then 'the cookbook will be created' do
  assert_cookbook_created('my_new_cookbook')
end

Then 'no placeholder example will be generated' do
  assert_no_example_generated
end

Then 'a placeholder example will be generated to describe the generated default recipe' do
  assert_example_generated('my_new_cookbook', 'default')
end

Then 'no examples will be found to run' do
  assert_no_examples_run
end

Then 'the example when run will be pending' do
  expect(spec_example_is_pending?).to be_true
end

Then 'the existing example will not be overwritten' do
  expect(spec_existing_example_not_overwritten?).to be_true
end

Then 'a placeholder example will be generated for each recipe' do
  ['default', 'chicken_tikka_masala', 'fish_and_chips', 'yorkshire_pudding'].each do |recipe|
    assert_example_generated('my_existing_cookbook', recipe)
  end
end

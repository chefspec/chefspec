Given /^a workstation with a Chef admin client$/ do
  steps %q{
    When I successfully run `knife -v`
  }
end

When /^I view the cookbook commands$/ do
  steps %q{
    When I run `knife cookbook --help`
  }
end

Then /^a command will exist to specify that a placeholder example should be generated$/ do
  steps %q{
    Then the output should match:
    """
    knife cookbook create_specs COOKBOOK \(options\)
    """
  }
end

When /^I issue the command to create a new cookbook( specifying that an example should be generated)?$/ do |do_generate|
  steps %Q{
    When I successfully run `knife cookbook create -o . my_new_cookbook`
    #{'When I successfully run `knife cookbook create_specs -o . my_new_cookbook`' unless do_generate.nil?}
  }
end

Then /^the cookbook will be created$/ do
  steps %q{
    Then the output should contain "Creating cookbook my_new_cookbook"
    Then a directory named "my_new_cookbook" should exist
    Then a file named "my_new_cookbook/recipes/default.rb" should exist
  }
end

Then /^no placeholder example will be generated$/ do
  steps %q{
    Then a directory named "my_new_cookbook/spec" should not exist
    Then a file named "my_new_cookbook/spec/default_spec.rb" should not exist
  }
end

Then /^a placeholder example will be generated to describe the generated default recipe$/ do
  steps %q{
    Then a directory named "my_new_cookbook/spec" should exist
    Then a file named "my_new_cookbook/spec/default_spec.rb" should exist
    Then the file "my_new_cookbook/spec/default_spec.rb" should contain "describe 'my_new_cookbook::default'"
  }
end

Then /^no examples will be found to run$/ do
  steps %q{
    When I successfully run `rspec my_new_cookbook`
    Then the output should contain "No examples found."
  }
end

Then /^the example when run will be pending$/ do
  steps %q{
    When I successfully run `rspec my_new_cookbook`
    Then the output should contain "Pending"
    Then the output should contain "my_new_cookbook::default should do something"
    Then the output should contain "# Your recipe examples go here."
    Then the output should contain "1 example, 0 failures, 1 pending"
  }
end
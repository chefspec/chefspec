Given /^a workstation with a Chef admin client$/ do
  steps %q{
    When I successfully run `knife -v`
  }
end

Given /^an existing cookbook with an example$/ do
  steps %q{
    Given a file named "cookbooks/my_existing_cookbook/recipes/default.rb" with:
    """ruby
      execute "print_hello_world" do
        command "echo Hello World!"
        action :run
      end
    """
  }
  steps %q{
    Given a file named "cookbooks/my_existing_cookbook/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      # I am an existing example - please don't overwrite me!
      describe "my_existing_cookbook::default" do
        let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should print hello world" do
          chef_run.should execute_command 'echo Hello World!'
        end
      end
    """
  }
end

Given /^an existing cookbook with four recipes but no examples$/ do
  ['default', 'chicken_tikka_masala', 'fish_and_chips', 'yorkshire_pudding'].each do |recipe|
    steps %Q{
      Given a file named "cookbooks/my_existing_cookbook/recipes/#{recipe}.rb" with:
      """ruby
        execute "prepare_#{recipe}" do
          command "echo Here is one I prepared earlier!"
          action :run
        end
      """
    }
  end
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

When /^I issue the command to generate placeholder examples$/ do
  steps %q{
    When I successfully run `knife cookbook create_specs -o cookbooks my_existing_cookbook`
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

Then /^the existing example will not be overwritten$/ do
  steps %q{
    Then the file "cookbooks/my_existing_cookbook/spec/default_spec.rb" should contain "# I am an existing example - please don't overwrite me!"
  }
end

Then /^a placeholder example will be generated for each recipe$/ do
  ['default', 'chicken_tikka_masala', 'fish_and_chips', 'yorkshire_pudding'].each do |recipe|
    steps %Q{
      Then a file named "cookbooks/my_existing_cookbook/spec/#{recipe}_spec.rb" should exist
      Then the file "cookbooks/my_existing_cookbook/spec/#{recipe}_spec.rb" should contain "describe 'my_existing_cookbook::#{recipe}'"
    }
  end
end
Given /^a Chef cookbook with a recipe that declares an execute resource$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      execute "print_hello_world" do
        command "echo Hello World!"
        action :run
      end
    """
  }
end

Given /^the recipe has a spec example that expects the command to be executed$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should print hello world" do
          chef_run.should execute_command 'echo Hello World!'
        end
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that has conditional execution based on operating system$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      case node.platform
        when "leprechaun", "sprite", "balloon"
          log("I am running on the #{node.platform} platform.")
        else
          log("This recipe is only supported on Leprechaun flavoured distros at this time.") { level :error }
      end
    """
  }
end

Then /^the command will not have been executed$/ do
  step %q{the stdout should not contain "Hello World!"}
end

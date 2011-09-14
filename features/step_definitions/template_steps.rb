Given /^a Chef cookbook with a recipe that declares a template resource$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      template "platform.txt" do
        action :create
      end
    """
    And a file named "cookbooks/example/templates/default/platform.txt.erb" with:
    """erb
    <%= @node[:platform] %>
    """
  }
end

Given /^the recipe has a spec example that expects the template to be rendered$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should create a file with the node platform" do
          @chef_run.should create_file("platform.txt")
        end
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that starts a service$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      service "food" do
        action :start
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that starts a service and enables it to start on boot$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      service "food" do
        action [:enable, :start]
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that stops a service$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      service "food" do
        action :stop
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that restarts a service$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      service "food" do
        action :restart
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that signals a service to reload$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      service "food" do
        action :reload
      end
    """
  }
end

Given /^the recipe has a spec example that expects the service to be started$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should ensure the food service is started" do
          @chef_run.should start_service "food"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the service to be started and enabled$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should ensure the food service is started and enabled" do
          @chef_run.should start_service "food"
          @chef_run.should set_service_to_start_on_boot "food"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the service to be stopped$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should ensure the food service is stopped" do
          @chef_run.should stop_service "food"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the service to be restarted/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should ensure the food service is restarted" do
          @chef_run.should restart_service "food"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the service to be reloaded/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should ensure the food service is reloaded" do
          @chef_run.should reload_service "food"
        end
      end
    """
  }
end

Then /^the service will not have been started$/ do

end

Then /^the service will not have been stopped$/ do

end

Then /^the service will not have been restarted$/ do

end

Then /^the service will not have been reloaded$/ do

end


Given /^a Chef cookbook with a recipe that logs a node attribute$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      log "The value of node.foo is: #{node.foo}"
    """
  }
end

Given /^the recipe has a spec example that sets a node attribute$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let(:chef_run) { ChefSpec::ChefRunner.new(:log_level => :debug){|n| n.foo = 'bar'}.converge 'example::default' }
        it "should log the node foo" do
          chef_run.should log "The value of node.foo is: bar"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that overrides the operating system to '([^']+)'$/ do |operating_system|
  @operating_system = operating_system
  steps %Q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let(:chef_run) { ChefSpec::ChefRunner.new(:log_level => :debug) }
        it "should log the node platform" do
          chef_run.node.automatic_attrs[:platform] = '#{operating_system}'
          chef_run.converge('example::default').should log 'I am running on the #{operating_system} platform.'
        end
      end
    """
  }
end

When /^the recipe example is successfully run$/ do
  steps %q{
    When I successfully run `rspec cookbooks/example/spec/`
    Then it should pass with:
    """
    , 0 failures
    """
  }
end

When /^the recipe example is unsuccessfully run$/ do
  steps %q{
    When I run `rspec cookbooks/example/spec/`
    Then it should fail with:
  """
  No such file or directory
  """
  }
end

Then /^the recipe will see the node attribute set in the spec example$/ do
  step %q{the stdout should contain "Processing log[The value of node.foo is: bar]"}
end

Then /^the resources declared for the operating system will be available within the example$/ do
  step %Q{the stdout should contain "Processing log[I am running on the #{@operating_system} platform.]"}
end

Given /^a Chef cookbook with a recipe that declares a cookbook file resource$/ do
  steps %Q{
    Given a file named "cookbooks/example/files/default/hello-world.txt" with:
      """
      hello world!
      """
    And a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      cookbook_file "hello-world.txt"
    """
  }
end

Given /^a Chef cookbook with a recipe that sets cookbook file ownership$/ do
  steps %q{
    Given a file named "cookbooks/example/files/default/hello-world.txt" with:
      """
      hello world!
      """
    And a file named "cookbooks/example/recipes/default.rb" with:
    """ruby
      cookbook_file "hello-world.txt" do
        owner "user"
        group "group"
      end
    """
    And a file named "hello-world.txt" with:
    """
    Hello world!
    """
  }
  @original_stat = owner_and_group 'hello-world.txt'
end

Given /^the recipe has a spec example that expects the cookbook file to be declared$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should create hello-world.txt" do
          chef_run.should create_cookbook_file 'hello-world.txt'
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the cookbook file to be set to be owned by a specific user$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """ruby
      require "chefspec"

      describe "example::default" do
        let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
        it "should set file ownership" do
          chef_run.cookbook_file('hello-world.txt').should be_owned_by('user', 'group')
        end
      end
    """
  }
end

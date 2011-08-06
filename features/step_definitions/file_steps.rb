Given /^a Chef cookbook with a recipe that declares a file resource$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      file "hello-world.txt" do
        content "hello world"
        action :create
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that deletes a file/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      file "hello-world.txt" do
        content "hello world"
        action :delete
      end
    """
      And a file named "hello-world.txt" with:
      """
      Hello world!
      """
  }
end

Given /^a Chef cookbook with a recipe that creates a directory$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      directory "foo" do
        action :create
      end
    """
  }
end

Given /^a Chef cookbook with a recipe that deletes a directory$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      directory "foo" do
        action :delete
      end
    """
    And a directory named "foo"
  }
end

Given /^a Chef cookbook with a recipe that sets file ownership$/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      file "hello-world.txt" do
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

Given /^a Chef cookbook with a recipe that sets directory ownership/ do
  steps %q{
    Given a file named "cookbooks/example/recipes/default.rb" with:
    """
      directory "foo" do
        owner "user"
        group "group"
      end
    """
    And a directory named "foo"
  }
  @original_stat = owner_and_group 'foo'
end

Given /^the recipe has a spec example that expects the file to be declared$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do
        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should create hello-world.txt" do
          @chef_run.should create_file "hello-world.txt"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the file to be deleted$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should delete hello-world.txt" do
          @chef_run.should delete_file "hello-world.txt"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the directory to be created/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should create the directory" do
          @chef_run.should create_directory "foo"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the directory to be deleted/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should delete the directory" do
          @chef_run.should delete_directory "foo"
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the file to be set to be owned by a specific user$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should set file ownership" do
          @chef_run.file("hello-world.txt").should be_owned_by("user", "group")
        end
      end
    """
  }
end

Given /^the recipe has a spec example that expects the directory to be set to be owned by a specific user$/ do
  steps %q{
    Given a file named "cookbooks/example/spec/default_spec.rb" with:
    """
      require "chefspec"

      describe "example::default" do

        before(:all) do
          @chef_run = ChefSpec::ChefRunner.new
          @chef_run.converge "example::default"
        end

        it "should set directory ownership" do
          @chef_run.directory("foo").should be_owned_by("user", "group")
        end
      end
    """
  }
end

Then /^the file will not have been created$/ do
  Then %q{the file "hello-world.txt" should not exist}
end

Then /^the file will not have been deleted/ do
  Then %q{a file named "hello-world.txt" should exist}
end

Then /^the directory will not have been created$/ do
  Then %q{a directory named "foo" should not exist}
end

Then /^the directory will not have been deleted$/ do
  Then %q{a directory named "foo" should exist}
end

Then /^the file will not have had its ownership changed$/ do
  @original_stat.should eql(owner_and_group 'hello-world.txt')
end

Then /^the directory will not have had its ownership changed$/ do
  @original_stat.should eql(owner_and_group 'foo')
end

def owner_and_group(path)
  stat = File.stat(File.join(current_dir, path))
  {:gid => stat.gid, :uid => stat.uid}
end
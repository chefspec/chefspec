[![Built on Travis](https://secure.travis-ci.org/acrmp/chefspec.png?branch=master)](http://travis-ci.org/acrmp/chefspec)

# Introduction

ChefSpec makes it easy to write examples for Opscode Chef cookbooks. Get fast
feedback on cookbook changes before you spin up a node to do integration
against.

ChefSpec runs your cookbook but without actually converging the node that your
examples are being executed on. This has two benefits:

* It's really fast!
* You can write examples that vary node attributes, operating system or search
  results in order to test thoroughly that your cookbok works correctly.

ChefSpec aims to make Chef development more productive by giving you faster
feedback on cookbook changes.

Start by watching Jim Hopp's excellent [Test Driven Development for Chef Practitioners](http://www.youtube.com/watch?v=o2e0aZUAVGw) talk from ChefConf which contains lots of great examples of using ChefSpec.

# Writing a cookbook example

This is an extremely basic Chef recipe that just installs an operating system package.

```ruby
1  package "foo" do
2    action :install
3  end
```

This is a matching spec file that defines an example that checks that the
package would be installed.

```ruby
1  require "chefspec"
2
3  describe "example::default" do
4    let (:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
5    it "should install foo" do
6      chef_run.should install_package 'foo'
7    end
8  end
```

Let's step through this spec file to see what is happening:

1. At the top of the spec file we require the chefspec gem.
1. The `describe` keyword is part of RSpec and indicates that everything from
   this line up until line 8 is describing the `example::default` recipe.
   Normally the convention is that you would have a separate spec file per
   recipe.
1. The `let` block on line 4 creates the ChefSpec runner and then does a fake
   Chef run with the run list of `example::default`. Any subsequent
   examples can then refer to `chef_run` in order to make assertions about the
   resources that were created during the mock converge.
1. The `it` block on line 5 is an example that specifies that the `foo` package
   should have been installed. Normally you will have multiple `it` blocks per
   recipe, each making a single assertion.

## Generating an example

Ideally you should be writing your specs in tandem with your recipes and
practicising TDD. However if you have an existing cookbook and you are using
Chef 0.10.0 or greater then ChefSpec can generate placeholder RSpec examples
for you. Knife will automagically detect the ChefSpec Knife Plugin and provide
you with the new `create_specs` subcommand.

You can choose to run this immediately after creating a new cookbook like so:

    $ knife cookbook create -o . my_new_cookbook
    $ knife cookbook create_specs -o . my_new_cookbook

The first command is a Knife built-in and will generate the standard Chef
cookbook structure, including a default recipe. The second is provided by
ChefSpec and will add a `specs` directory and a `default_spec.rb` placeholder.

You'll see the following output:

    ** Creating specs for cookbook: my_new_cookbook

If you look at the generated example you'll see that on line 6 there is a
`pending` keyword indicating where you will later add your cookbook example:

    $ cat -n my_new_cookbook/spec/default_spec.rb

```ruby
1  require 'chefspec'
2
3  describe 'my_new_cookbook::default' do
4    let (:chef_run) { ChefSpec::ChefRunner.new.converge 'my_new_cookbook::default' }
5    it 'should do something' do
6      pending 'Your recipe examples go here.'
7    end
8  end
```

You can run the example using rspec:

    $ rspec my_new_cookbook

And you'll see output similar to the following:

    Pending:
      my_new_cookbook::default should do something
        # Your recipe examples go here.
        # ./my_new_cookbook/spec/default_spec.rb:5

    Finished in 0.00051 seconds
    1 example, 0 failures, 1 pending

# Examples should do more than restate static resources

Being able to write examples for simple cases like this is of some use, but
because you declare resources in Chef declaratively it can feel like you are
merely repeating the same resources in example form.

However the recipes that you write using Chef will often declare different
resources based on different inputs:

1. The node attributes for the node converged.
1. The automatically populated node attributes provided by Ohai (operating
   system and version are examples of these).
1. Search results from search queries performed within the recipe.
1. Lookup of values from within databags.

This is where ChefSpec really starts to shine. ChefSpec makes it possible to
write examples for all of the variations of the different inputs above and
make assertions about the created resources. Verifying correct behaviour
for all of the variations with real converges can be incredibly time consuming.
Doing this with real converges is prohibitively slow, but with ChefSpec you can
identify regressions very quickly while developing your cookbook.

## Setting node attributes

You can set node attributes within an individual example. In this example
the value of the `foo` attribute will be set to `bar` on line 3. The example
then asserts that a resource is created based on the attribute name.
In this example the affected resource is a log resource, but it could just as
easily be a template or package name derived from an attribute value.

```ruby
1  it "should log the foo attribute" do
2    chef_run = ChefSpec::ChefRunner.new
3    chef_run.node.foo = 'bar'
4    chef_run.converge 'example::default'
5    chef_run.should log 'The value of node.foo is: bar'
6  end
```

A common mistake is to call `#converge` on the runner before setting the node
attributes. If you do this then the attributes will not be set correctly.

```ruby
1  # Don't do this
2  it "should log the foo attribute" do
3    chef_run = ChefSpec::ChefRunner.new.converge 'example::default'
4    chef_run.node.foo = 'bar'
5    chef_run.should log 'The value of node.foo is: bar'
6  end
```

To avoid this, you can make use of the alternative syntax for specifying node
attributes. Using this approach you pass a block when creating the runner.

```ruby
1  chef_run = ChefSpec::ChefRunner.new do |node|
2    node['my_attribute'] = 'bar'
3    node['my_other_attribute'] = 'bar2'
4  end
5  chef_run.converge 'example::default'
```

## Ohai Attributes

When you converge a node using Chef a large number of attributes are
pre-populated by Chef which runs
[Ohai](http://wiki.opscode.com/display/chef/Ohai) to discover information about
the node it is running on.

You can use these attributes within your cookbooks - the most common usage is
to declare different resources based on the node platform (operating system)
but Ohai ships with a large number of plugins that discover everything from
hardware to installed language interpreters.

It's useful to be able to override these values from within your cookbook
examples in order to assert the resources created on different platforms. In
this way you can explore all of the code paths within your cookbook despite
running the examples on a different platform altogether. Note that line 2
declares the platform underneath `automatic_attrs`.

```ruby
1  chef_run = ChefSpec::ChefRunner.new
2  chef_run.node.automatic_attrs[:platform] = 'Commodore 64'
3  chef_run.converge('example::default').should log
4    'I am running on a Commodore 64.'
```

### Missing attributes

Because Ohai runs a large number of plugins by default, many community cookbooks
will assume that a node attribute will be present, and will fail unless a value
is provided. Providing values for each of these attributes can detract from the
readability of your examples.

[Fauxhai](https://github.com/customink/fauxhai) from Seth Vargo is a promising
solution to this problem because it enables you to re-use sanitized Ohai
attribute profiles by name, rather than being required to provide each attribute
individually. For more on Fauxhai
[check out this blog post](http://technology.customink.com/blog/2012/08/03/testing-chef-cookbooks/)
from CustomInk.

## Search Results

Chef cookbooks will often make use of search in order to locate other services
within your infrastructure. An example would be a load balancer that searches
for the webservers to add to its pool.

You can use the built-in features within RSpec to stub out responses to search
queries. Given a recipe that searches for webservers:

```ruby
1  search(:node, 'role:web') do |web_node|
2    log "Adding webserver to the pool: #{web_node['hostname']}"
3  end
```

A example that returned a pre-canned search result to the recipe and then
asserted that it then logged each node added to the pool might look like this:

```ruby
1  it "should log each node added to the load balancer pool" do
2    Chef::Recipe.any_instance.stub(:search).with(:node, 'role:web').and_yield(
3      {'hostname' => 'web1.example.com'})
4    chef_run = ChefSpec::ChefRunner.new
5    chef_run.converge 'my_new_cookbook::default'
6    chef_run.should log 'Adding webserver to the pool: web1.example.com'
7  end
```

Line 2 defines the search response for a search for all nodes with the `web`
role. Line 6 then asserts that the hostname of the returned node is logged as
expected.

# Making Assertions

Now you have a clear understanding of how to modify the attributes available to
your cookbook it's time to explore the support available in ChefSpec for
expressing assertions.

Each example (within the `it` block) has to specify an assertion to be useful.
An assertion is a statement about the resources created by your Chef run that
the node will be converged against.

## Files

A basic form of assertion is to check that a file is created by a cookbook
recipe. Note that this won't work for files or directories that are not
explicitly declared as resources in the recipe. For example directories created
by the installation of a new package are not known to ChefSpec, it is only
aware of resources that are defined within your cookbooks.

Assert that a directory would be created:

```ruby
chef_run.should create_directory '/var/lib/foo'
```

Assert that a directory would be deleted:

```ruby
chef_run.should delete_directory '/var/lib/foo'
```

Assert that a directory would have the correct ownership:

```ruby
chef_run.directory('/var/lib/foo').should be_owned_by('user', 'group')
```

Assert that a file would be created:

```ruby
chef_run.should create_file '/var/log/bar.log'
```

Assert that a file would be deleted:

```ruby
chef_run.should delete_file '/var/log/bar.log'
```

Assert that a file would have the correct ownership:

```ruby
chef_run.file('/var/log/bar.log').should be_owned_by('user', 'group')
```

Assert that a file would have the expected content:

```ruby
chef_run.should create_file_with_content 'hello-world.txt', 'hello world'
```

## Packages

Note that only packages explicitly declared in the cookbook will be matched by
these assertions. For example, a package installed only as a dependency of
another package would not be matched.

Assert that a package would be installed:

```ruby
chef_run.should install_package 'foo'
```

Assert that a package would be installed at a fixed version:

```ruby
chef_run.should install_package_at_version 'foo', '1.2.3'
```

Assert that a package would be removed:

```ruby
chef_run.should remove_package 'foo'
```

Assert that a package would be purged:

```ruby
chef_run.should purge_package 'foo'
```

Assert that a package would be upgraded:

```ruby
chef_run.should upgrade_package 'foo'
```

All of the assertions above are also valid for use with RubyGems:

```ruby
chef_run.should install_gem_package 'foo'
```

## Execute

If you make use of the `execute` resource within your cookbook recipes it is
important to guard for idempotent behaviour. ChefSpec is not smart enough
at present to be used to verify that an `only_if` or `not_if` condition would
be met however.

Assert that a command would be run:

```ruby
chef_run.should execute_command 'whoami'
```

Assert that a command would not be run:

```ruby
chef_run.should_not execute_command 'whoami'
```

## Logging

You can assert that a log resource will be created. Note that this assertion
will not match direct use of `Chef::Log`.

Assert that a log statement would be logged:

```ruby
chef_run.should log 'A log message from my recipe'
```

If you want to be able to view the log output at the console you can control
the logging level when creating an instance of `ChefRunner` as below:

```ruby
let(:chef_run) { ChefSpec::ChefRunner.new(:log_level => :debug) }
```

## Services

Assert that a daemon would be started:

```ruby
chef_run.should start_service 'food'
```

Assert that a daemon would be started when the node boots:

```ruby
chef_run.should set_service_to_start_on_boot 'food'
```

Assert that a daemon would be stopped:

```ruby
chef_run.should stop_service 'food'
```

Assert that a daemon would be restarted:

```ruby
chef_run.should restart_service 'food'
```

Assert that a daemon would be reloaded:

```ruby
chef_run.should reload_service 'food'
```

# Varying the cookbook path

By default chefspec will infer the `cookbook_path` from the location of the
spec. However if you want to use a different path you can pass it in as an
argument to the `ChefRunner` constructor like so:

```ruby
 1 require 'chefspec'
 2
 3 describe 'foo::default' do
 4   let (:chef_run) {
 5     runner = ChefSpec::ChefRunner.new({:cookbook_path => '/some/path'})
 6     runner.converge 'foo::default'
 7     runner
 8   }
 9   it 'installs the foo package' do
10     chef_run.should install_package 'foo'
11   end
12 end
```

# Writing examples for LWRP's

By default chefspec will override all resources to take no action. In order to allow
your LWRP to be run, you have to explicitly tell `ChefRunner` to step into it:

```ruby
 1 require 'chefspec'
 2
 3 describe 'foo::default' do
 4   let(:chef_run) {
 5     runner = ChefSpec::ChefRunner.new(:step_into => ['my_lwrp'])
 6     runner.converge 'foo::default'
 7   }
 8   it 'installs the foo package through my_lwrp' do
 9     chef_run.should install_package 'foo'
10   end
11 end
```

# Building

    $ bundle install
    $ bundle exec rake

# Continuous Integration
[Chefspec on Travis CI](http://travis-ci.org/acrmp/chefspec)

# License
MIT - see the accompanying [LICENSE](https://github.com/acrmp/chefspec/blob/master/LICENSE) file for details.

# Changelog
To see what has changed in recent versions see the [CHANGELOG](https://github.com/acrmp/chefspec/blob/master/CHANGELOG.md). ChefSpec follows the [Rubygems RationalVersioningPolicy](http://docs.rubygems.org/read/chapter/7).

# Contributing
Additional matchers and bugfixes are welcome! Please fork and submit a pull request on an individual branch per change.

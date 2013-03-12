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
package "foo" do
  action :install
end
```

This is a matching spec file that defines an example that checks that the
package would be installed.

```ruby
require "chefspec"

describe "example::default" do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
  it "should install foo" do
    expect(chef_run).to install_package 'foo'
  end
end
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
require 'chefspec'

describe 'my_new_cookbook::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'my_new_cookbook::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
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
it "should log the foo attribute" do
  chef_run = ChefSpec::ChefRunner.new
  chef_run.node.set['foo'] = 'bar'
  chef_run.converge 'example::default'
  expect(chef_run).to log 'The value of node.foo is: bar'
end
```

A common mistake is to call `#converge` on the runner before setting the node
attributes. If you do this then the attributes will not be set correctly.

```ruby
# !!! Don't do this !!!
it "should log the foo attribute" do
  chef_run = ChefSpec::ChefRunner.new.converge 'example::default'
  chef_run.node.set['foo'] = 'bar'
  expect(chef_run).to log 'The value of node.foo is: bar'
end
```

To avoid this, you can make use of the alternative syntax for specifying node
attributes. Using this approach you pass a block when creating the runner.

```ruby
chef_run = ChefSpec::ChefRunner.new do |node|
  node['my_attribute'] = 'bar'
  node['my_other_attribute'] = 'bar2'
end
chef_run.converge 'example::default'
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
chef_run = ChefSpec::ChefRunner.new
chef_run.node.automatic_attrs['platform'] = 'Commodore 64'
expect(chef_run.converge('example::default')).to log 'I am running on a Commodore 64.'
```

### "Missing" attributes

[Fauxhai](https://github.com/customink/fauxhai) from Seth Vargo is now a dependency of ChefSpec. This means you leverage all the power of fauxhai (and it's community contributed ohai mocks) without additional configuration. Just specify the `platform` and `version` attributes when you instantiate your `ChefRunner`:

```ruby
chef_run = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04') do |node|
  node.set['my_attribute'] = 'bar'
  node.set['my_other_attribute'] = 'bar2'
end
chef_run.converge 'example::default'
```

This will include all the default attributes for Ubuntu Precise 12.04. By default, ChefSpec uses the built-in ChefSpec environment (which is minimally configured) for backward compatibility.

For more on Fauxhai
[check out this blog post](http://technology.customink.com/blog/2012/08/03/testing-chef-cookbooks/) from CustomInk.

## Search Results

Chef cookbooks will often make use of search in order to locate other services
within your infrastructure. An example would be a load balancer that searches
for the webservers to add to its pool.

You can use the built-in features within RSpec to stub out responses to search
queries. Given a recipe that searches for webservers:

```ruby
search(:node, 'role:web') do |web_node|
  log "Adding webserver to the pool: #{web_node['hostname']}"
end
```

A example that returned a pre-canned search result to the recipe and then
asserted that it then logged each node added to the pool might look like this:

```ruby
it "should log each node added to the load balancer pool" do
  Chef::Recipe.any_instance.stub(:search).with(:node, 'role:web').and_yield(
    {'hostname' => 'web1.example.com'})
  chef_run = ChefSpec::ChefRunner.new
  chef_run.converge 'my_new_cookbook::default'
  expect(chef_run).to log 'Adding webserver to the pool: web1.example.com'
end
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
expect(chef_run).to create_directory '/var/lib/foo'
```

Assert that a directory would be deleted:

```ruby
expect(chef_run).to delete_directory '/var/lib/foo'
```

Assert that a directory would have the correct ownership:

```ruby
directory = chef_run.directory('/var/lib/foo')
expect(directory).to be_owned_by('user', 'group')
```

Assert that a file would be created:

```ruby
expect(chef_run).to create_file '/var/log/bar.log'
```

Assert that a file would be deleted:

```ruby
expect(chef_run).to delete_file '/var/log/bar.log'
```

Assert that a file would have the correct ownership:

```ruby
file = chef_run.file('/var/log/bar.log')
expect(file).to be_owned_by('user', 'group')
```

Assert that a file would have the expected content (matches on partial content):

```ruby
expect(chef_run).to create_file_with_content 'hello-world.txt', 'hello world'
```

Assert that a remote file would be created:

```ruby
expect(chef_run).to create_remote_file '/tmp/foo.tar.gz'
```

Assert that a remote file with specific attributes would be created:

```ruby
chef_run.should create_remote_file('/tmp/foo.tar.gz').with(
  :source => 'http://www.example.com/foo.tar.gz',
  :checksum => 'deadbeef'
)
```

## Packages

Note that only packages explicitly declared in the cookbook will be matched by
these assertions. For example, a package installed only as a dependency of
another package would not be matched.

Assert that a package would be installed:

```ruby
expect(chef_run).to install_package 'foo'
```

Assert that a package would be installed at a fixed version:

```ruby
expect(chef_run).to install_package_at_version 'foo', '1.2.3'
```

Assert that a package would be removed:

```ruby
expect(chef_run).to remove_package 'foo'
```

Assert that a package would be purged:

```ruby
expect(chef_run).to purge_package 'foo'
```

You can even use yum packages:

```ruby
chef_run.should install_yum_package 'yum-foo'
```

Assert that a package would be upgraded:

```ruby
expect(chef_run).to upgrade_package 'foo'
```

All of the assertions above are also valid for use with RubyGems:

```ruby
expect(chef_run).to install_gem_package 'foo'
```

```ruby
expect(chef_run).to install_chef_gem_package 'chef-foo'
```

## Execute

If you make use of the `execute` resource within your cookbook recipes it is
important to guard for idempotent behaviour. ChefSpec is not smart enough
at present to be used to verify that an `only_if` or `not_if` condition would
be met however.

Assert that a command with specific attributes would be run:

```ruby
expect(chef_run).to execute_command('whoami > me').with(
  :cwd => '/tmp',
  :creates => '/tmp/me'
)
```

Assert that a command would not be run:

```ruby
expect(chef_run).not_to execute_command 'whoami'
```

## Scripts

You can assert that a script will be executed via the `script` resource or one of
its shortcuts (`bash`, `csh`, `perl`, `python`, `ruby`).

Assert that a Bash script would be run:

```ruby
expect(chef_run).to execute_bash_script 'name of bash script'
```

Assert that a Csh script would be run:

```ruby
expect(chef_run).to execute_csh_script 'name of csh script'
```

Assert that a Perl script would be run:

```ruby
expect(chef_run).to execute_perl_script 'name of perl script'
```

Assert that a Python script would be run:

```ruby
expect(chef_run).to execute_python_script 'name of python script'
```

Assert that a Ruby script would be run:

```ruby
expect(chef_run).to execute_ruby_script 'name of ruby script'
```

Note: To check for the `ruby_block` resource, use the `execute_ruby_block`
matcher described below.

## Logging

You can assert that a log resource will be created. Note that this assertion
will not match direct use of `Chef::Log`.

Assert that a log statement would be logged:

```ruby
expect(chef_run).to log 'A log message from my recipe'
```

Assert that at least one log statement would match a specified regexp:

```ruby
expect(chef_run).to log(/bacon \d+/)
```

If you want to be able to view the log output at the console you can control
the logging level when creating an instance of `ChefRunner` as below:

```ruby
let(:chef_run) { ChefSpec::ChefRunner.new(:log_level => :debug) }
```

## Services

Assert that a daemon would be started:

```ruby
expect(chef_run).to start_service 'food'
```

Assert that a daemon would be started when the node boots:

```ruby
expect(chef_run).to set_service_to_start_on_boot 'food'
```

Assert that a daemon would be stopped:

```ruby
expect(chef_run).to stop_service 'food'
```

Assert that a daemon would be restarted:

```ruby
expect(chef_run).to restart_service 'food'
```

Assert that a daemon would be reloaded:

```ruby
expect(chef_run).to reload_service 'food'
```

## Recipes

Assert that a recipe would be included:

```ruby
expect(chef_run).to include_recipe 'foo::bar'
```

## Ruby blocks

Assert that a ruby block would be executed:

```ruby
expect(chef_run).to execute_ruby_block 'ruby_block_name'
```

Assert that a ruby block would not be executed:

```ruby
expect(chef_run).not_to execute_ruby_block 'ruby_block_name'
```

# Varying the cookbook path

By default chefspec will infer the `cookbook_path` from the location of the
spec. However if you want to use a different path you can pass it in as an
argument to the `ChefRunner` constructor like so:

```ruby
require 'chefspec'

describe 'foo::default' do
  let(:chef_run) {
    runner = ChefSpec::ChefRunner.new({:cookbook_path => '/some/path'})
    runner.converge 'foo::default'
    runner
  }
  it 'installs the foo package' do
    expect(chef_run).to install_package 'foo'
  end
end
```

# Mocking out environments
If you want to mock out `node.chef_environment`, you'll need to use RSpec mocks/stubs twice:

```ruby
let(:chef_run) do
  ChefSpec::ChefRunner.new do |node|
    # Create a new environment (you could also use a different :let block or :before block)
    env = Chef::Environment.new
    env.name 'staging'

    # Stub the node to return this environment
    node.stub(:chef_environment).and_return env.name

    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return env
  end.converge 'cookbook::recipe'
end
```


See #54 for the in-depth discussion.

# Writing examples for LWRP's

By default chefspec will override all resources to take no action. In order to allow
your LWRP to be run, you have to explicitly tell `ChefRunner` to step into it:

```ruby
require 'chefspec'

describe 'foo::default' do
  let(:chef_run) {
    runner = ChefSpec::ChefRunner.new(:step_into => ['my_lwrp'])
    runner.converge 'foo::default'
  }
  it 'installs the foo package through my_lwrp' do
    expect(chef_run).to install_package 'foo'
  end
end
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

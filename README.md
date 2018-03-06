# ChefSpec

[![Gem Version](https://badge.fury.io/rb/chefspec.svg)](https://badge.fury.io/rb/chefspec) [![Build Status](https://travis-ci.org/chefspec/chefspec.svg?branch=master)](https://travis-ci.org/chefspec/chefspec)

ChefSpec is a unit testing framework for testing Chef cookbooks. ChefSpec makes it easy to write examples and get fast feedback on cookbook changes without the need for virtual machines or cloud servers.

ChefSpec runs your cookbook(s) locally with Chef Solo without actually converging a node. This has two primary benefits:

- It's really fast!
- Your tests can vary node attributes, operating systems, and search results to assert behavior under varying conditions.

## Important Notes

- **ChefSpec requires Ruby 2.2 or later and Chef 12.14.89 or later!**
- **This documentation corresponds to the master branch, which may be unreleased. Please check the README of the latest git tag or the gem's source for your version's documentation!**
- **Each resource matcher is self-documented using [Yard](http://rubydoc.info/github/chefspec/chefspec) and has a corresponding test recipe in the [examples directory](https://github.com/chefspec/chefspec/tree/master/examples).**

## Notes on Compatibility with Chef Versions

**ChefSpec aims to maintain compatibility with the two most recent minor versions of Chef.** If you are running an older version of Chef it may work, or you will need to run an older version of ChefSpec.

As a general rule, if it is tested in the Travis CI matrix, it is a supported version. The section below details any specific versions that are _not_ supported and why:

## Writing a Cookbook Example

If you want `knife` to automatically generate spec stubs for you, install [knife-spec](https://github.com/sethvargo/knife-spec).

Given an extremely basic Chef recipe that just installs an operating system package:

```ruby
package 'foo'
```

the associated ChefSpec test might look like:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'installs foo' do
    expect(chef_run).to install_package('foo')
  end
end
```

Let's step through this file to see what is happening:

1. At the top of the spec file we require the chefspec gem. This is required so that our custom matchers are loaded. In larger projects, it is common practice to create a file named "spec_helper.rb" and include ChefSpec and perform other setup tasks in that file.
2. The `describe` keyword is part of RSpec and indicates that everything nested beneath is describing the `example::default` recipe. The convention is to have a separate spec for each recipe in your cookbook.
3. The `let` block on creates the `ChefSpec:SoloRunner` with mocked Ohai data for Ubuntu 16.04 from [Fauxhai](https://github.com/chefspec/fauxhai). It then does a fake Chef run with the run_list of `example::default`. Any subsequent examples can then refer to `chef_run` in order to make assertions about the resources that were created during the mock converge.
4. The `described_recipe` macro is a ChefSpec helper method that infers the recipe from the `describe` block. Alternatively you could specify the recipe directly.
5. The `it` block is an example specifying that the `foo` package is installed. Normally you will have multiple `it` blocks per recipe, each making a single assertion.

## Configuration

ChefSpec exposes a configuration layer at the global level and at the `Runner` level. The following settings are available:

```ruby
RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks (default: [inferred from
  # the location of the calling spec file])
  config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  config.role_path = '/var/roles'

  # Specify the path for Chef Solo to find environments (default: [ascending search])
  config.environment_path = '/var/environments'

  # Specify the path for Chef Solo file cache path (default: nil)
  config.file_cache_path = Chef::Config[:file_cache_path]

  # Specify the Chef log_level (default: :warn)
  config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data (default: nil)
  config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '14.04'
end
```

Values specified at the initialization of a "Runner" merge and take precedence over any global settings:

```ruby
# Override only the operating system version (platform is still "ubuntu" from above)
ChefSpec::SoloRunner.new(version: '16.04')

# Use a different operating system platform and version
ChefSpec::SoloRunner.new(platform: 'centos', version: '7.3.1611')

# Specify a different cookbook_path
ChefSpec::SoloRunner.new(cookbook_path: '/var/my/other/path', role_path: '/var/my/roles')

# By default ChefSpec sets a new temporary directory for file caching in every run.
# This can be overridden by passing the `file_cache_path` option.
# Note: Resources containing `Chef::Config[:file_cache_path]` in their name or
# attributes, will fail unless this option is specified.
ChefSpec::SoloRunner.new(file_cache_path: Chef::Config[:file_cache_path])

# Add debug log output
ChefSpec::SoloRunner.new(log_level: :debug).converge(described_recipe)
```

**NOTE** You do not _need_ to specify a platform and version to use ChefSpec. However, some cookbooks may rely on [Ohai](http://github.com/chef/ohai) data that ChefSpec cannot not automatically generate. Specifying the `platform` and `version` keys instructs ChefSpec to load stubbed Ohai attributes from another platform using [fauxhai](https://github.com/chefspec/fauxhai). See the [PLATFORMS.md file](https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md) in the Fauxhai repo for a complete list of platforms and versions for use with ChefSpec.

### ChefZero Server

The `ServerRunner` uses a [chef-zero](https://github.com/chef/chef-zero) instance as a stand-in for a full Chef Server. The instance is created at the initiation of the ChefSpec suite and is terminated at its completion. In between each test the state of the ChefZero server is completely reset.

```ruby
RSpec.configure do |config|
  # When using ChefSpec::ServerRunner, specify the data storage method (options: in_memory, on_disk; default: in_memory)
  # If you are in a low-memory environment, setting this value to :on_disk may improve speed and/or reliability.
  config.server_runner_data_store = :on_disk

  # Whether or not to clear the cookbooks on the ChefZero instance in-between each test (default: true)
  # For most people, not clearing the cookbooks will drastically improve test execution time. This is a
  # good option for people who are using chefspec within the context of a single Berksfile or Policyfile.
  config.server_runner_clear_cookbooks = false
end
```

### Berkshelf

If you are using Berkshelf, simply require `chefspec/berkshelf` in your `spec_helper` after requiring `chefspec`:

```ruby
# spec_helper.rb
require 'chefspec'
require 'chefspec/berkshelf'
```

Requiring this file will:

- Create a temporary working directory
- Download all the dependencies listed in your `Berksfile` into the temporary directory
- Set ChefSpec's `cookbook_path` to the temporary directory

You can customize the list of options passed to the installation command using the `berkshelf_options` RSpec configuration:

```ruby
RSpec.configuration do |config|
  config.berkshelf_options = { only: "my-group" }
end
```

This is a Ruby hash and valid options include `only` and `except`.

### Librarian

If you are using Librarian, simply require `chefspec/librarian` in your `spec_helper` after requiring `chefspec`:

```ruby
# spec_helper.rb
require 'chefspec'
require 'chefspec/librarian'
```

Requiring this file will:

- Create a temporary working directory
- Download all the dependencies listed in your `Cheffile` into the temporary directory
- Set ChefSpec's `cookbook_path` to the temporary directory

**NOTE** In order to test the cookbook in the current working directory, you have to write your `Cheffile` like this:

```ruby
# Cheffile
site 'https://supermarket.chef.io/api/v1'

cookbook 'name_of_your_cookbook', path: '.'
```

### Policyfile

If you are using Chef Policies with ChefDK, simply require `chefspec/policyfile` in your `spec_helper`, and ensure you are using the `ChefSpec::ServerRunner` - Chef Solo does not support the exported repository format because the cookbook names use the unique version identifier.

```ruby
# spec_helper.rb
require 'chefspec'
require 'chefspec/policyfile'
```

Requiring this file will:

- Create a temporary working directory
- Download all the dependencies listed in your `Policyfile.rb` into the temporary directory
- Set ChefSpec's `cookbook_path` to the temporary directory

Your `Policyfile.rb` should look something like this:

```ruby
name 'my-cookbook'
run_list 'my-cookbook::default'
default_source :community
cookbook 'my-cookbook', path: '.'
```

## Running Specs

ChefSpec is actually an RSpec extension, so you can run your tests using the RSpec CLI:

```bash
$ rspec
```

You can also specify a specific spec to run and various RSpec command line options:

```bash
$ rspec spec/unit/recipes/default_spec.rb --color
```

For more information on the RSpec CLI, please see the [documentation](https://relishapp.com/rspec/rspec-core/docs/command-line).

## Making Assertions

ChefSpec asserts that resource actions have been performed. In general, ChefSpec follows the following pattern:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'does something' do
    expect(chef_run).to ACTION_RESOURCE(NAME)
  end
end
```

where:

- _ACTION_ - the action on the resource (e.g. `install`)
- _RESOURCE_ - the name of the resource (e.g. `package`)
- _NAME_ - the name attribute for the resource (e.g. `apache2`)

**NOTE** One exception to this rule is the `create_if_missing` action on the `file` resource. In this case the assertion is actually `create_file_if_missing`. Refer to `examples/file/spec/create_if_missing_spec.rb` for some examples.

Here's a more concrete example:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs apache2' do
    expect(chef_run).to install_package('apache2')
  end
end
```

This test is asserting that the Chef run will have a _package_ resource with the name _apache2_ with an action of _install_.

To test that a resource action is performed with a specific set of attributes, you can call `with(ATTRIBUTES_HASH)` on the expectation, per the following example:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'adds the member vagrant to the docker group' do
    expect(chef_run).to modify_group('docker').with(members: ['vagrant'])
  end
end
```

This test is asserting that the Chef run will have a _group_ resource with the name _docker_, an action of _modify_, and an attributes hash including `{ members: ['vagrant'] }`.

ChefSpec includes matchers for all of Chef's core resources using the above schema. Each resource matcher is self-documented using [Yard](http://rubydoc.info/github/chefspec/chefspec) and has a corresponding cucumber test from the [examples directory](https://github.com/chefspec/chefspec/tree/master/examples).

Additionally, ChefSpec includes the following helpful matchers. They are also [documented in Yard](http://rubydoc.info/github/chefspec/chefspec), but they are included here because they do not follow the "general pattern".

### include_recipe

Assert that the Chef run included a recipe from another cookbook

```ruby
expect(chef_run).to include_recipe('other_cookbook::recipe')
```

Keep the resources from an included recipe from being loaded into the Chef run, but test that the recipe was included

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('other_cookbook::default')
  end

  it 'includes the other_cookbook' do
    expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('other_cookbook::default')
    chef_run
  end
end
```

### notify

Assert that a resource notifies another in the Chef run

```ruby
resource = chef_run.template('/etc/foo')
expect(resource).to notify('service[apache2]').to(:restart).immediately
```

### subscribes

Assert that a resource subscribes to another in the Chef run

```ruby
resource = chef_run.service('apache2')
expect(resource).to subscribe_to('template[/etc/foo]').on(:create).delayed
```

### render_file

Assert that the Chef run renders a file (with optional content); this will match `cookbook_file`, `file`, and `template` resources and can also check the resulting content

```ruby
expect(chef_run).to render_file('/etc/foo')
expect(chef_run).to render_file('/etc/foo').with_content('This is content')
expect(chef_run).to render_file('/etc/foo').with_content(/regex works too.+/)
expect(chef_run).to render_file('/etc/foo').with_content { |content|
  # Regular RSpec matches work in here
  expect(content).to include('any RSpec matcher')
}
```

You can use any RSpec content matcher inside of the `with_content` predicate:

```ruby
expect(chef_run).to render_file('/etc/foo').with_content(start_with('# First line'))
```

It is possible to assert which [Chef phase of execution](https://docs.chef.io/chef_client.html#the-chef-client-title-run) a resource is created. Given a resource that is installed at compile time using `run_action`:

```ruby
package('apache2').run_action(:install)
```

You can assert that this package is installed during runtime using the `.at_compile_time` predicate on the resource matcher:

```ruby
expect(chef_run).to install_package('apache2').at_compile_time
```

Similarly, you can assert that a resource is executed during convergence time:

```ruby
expect(chef_run).to install_package('apache2').at_converge_time
```

Since "converge time" is the default behavior for all recipes, this test might be redundant and the predicate could be dropped depending on your situation.

### do_nothing

Assert that a resource performs no action

```ruby
resource = chef_run.execute('install')
expect(resource).to do_nothing
```

**For more complex examples, please see the [examples directory](https://github.com/chefspec/chefspec/tree/master/examples) or the [Yard documentation](http://rubydoc.info/github/chefspec/chefspec).**

## Specifying Node Information

Node information can be set when creating the `Runner`. The initializer yields a block that gives full access to the node object:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.name 'test.node-1'
    end.converge(described_recipe)
  end

  it 'has node name set' do
    expect(chef_run.node.name).to eq('test.node-1')
  end
end
```

### Setting Node Attributes

Node attributes can also be set inside the initializer block:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['cookbook']['attribute'] = 'hello'
    end.converge(described_recipe)
  end
end
```

### Automatic attributes

ChefSpec provides mocked automatic Ohai data using [fauxhai](https://github.com/chefspec/fauxhai). To mock out `automatic` attributes, you must use the `automatic` key:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.automatic['memory']['total'] = '512kB'
    end.converge(described_recipe)
  end
end
```

The `node` that is returned is actually a [`Chef::Node`](https://docs.chef.io/nodes.html) object.

To set an attribute within a specific test, set the attribute in the `it` block and then **(re-)converge the node**:

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new } # Notice we don't converge here

  it 'performs the action' do
    chef_run.node.normal['cookbook']['attribute'] = 'hello'
    chef_run.converge(described_recipe) # The converge happens inside the test

    expect(chef_run).to do_something
  end
end
```

## Using a Chef Server

All the examples thus far have used the `ChefSpec::SoloRunner`, which runs ChefSpec in Chef Solo mode. ChefSpec also includes the ability to create in-memory Chef Servers. This server can be populated with fake data and used to test search, data bags, and other "server-only" features.

To use the ChefSpec server, simply replace `ChefSpec::SoloRunner` with `ChefSpec::ServerRunner`:

```diff
describe 'example::default' do
-  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
+  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }
end
```

This will automatically create a Chef Server, synchronize all the cookbooks in your `cookbook_path`, and wire all the internals of Chef together. Recipe calls to `search`, `data_bag` and `data_bag_item` will now query this ChefSpec server.

### DSL

The ChefSpec server includes a collection of helpful DSL methods for populating data into the Chef Server.

Create a client:

```ruby
ChefSpec::ServerRunner.new do |node, server|
  server.create_client('my_client', { admin: true })
end
```

Create a data bag (and items):

```ruby
ChefSpec::ServerRunner.new do |node, server|
  server.create_data_bag('my_data_bag', {
    'item_1' => {
      'password' => 'abc123'
    },
    'item_2' => {
      'password' => 'def456'
    }
  })
end
```

Create an environment:

```ruby
ChefSpec::ServerRunner.new do |node, server|
  server.create_environment('my_environment', { default_attributes: { description: '...' } })
end
```

Create a node:

```ruby
ChefSpec::ServerRunner.new do |node, server|
  server.create_node('my_node', { run_list: ['...'] })
end
```

Note: the current "node" is always uploaded to the server. However, due to the way the Chef Client compiles cookbooks, you must update the current node on the server if any attributes are changed:

```ruby
ChefSpec::ServerRunner.new do |node, server|
  node.normal['attribute'] = 'value'

  # At this point, the server already has a copy of the current node object due
  # to the way Chef compiled the resources. However, that node does not have
  # this new value. As such, you must "save" the node back to the server to
  # persist this attribute update.
  server.update_node(node)
end
```

You may also use the `stub_node` macro, which will create a new `Chef::Node` object and accepts the same parameters as the Chef Runner and a Fauxhai object:

```ruby
www = stub_node(platform: 'ubuntu', version: '16.04') do |node|
        node.normal['attribute'] = 'value'
      end

# `www` is now a local Chef::Node object you can use in your test. To publish
# this node to the server, call `create_node`:

ChefSpec::ServerRunner.new do |node, server|
  server.create_node(www)
end
```

Create a role:

```ruby
ChefSpec::ServerRunner.new do |node, server|
  server.create_role('my_role', { default_attributes: {} })
end
```

**NOTE** The ChefSpec server is empty at the start of each example to avoid interdependent tests.

### Data Store

The `ServerRunner` has two options for how it will store data: `in_memory` or `on_disk`. The default value is `in_memory`. These two options have different performance implications based on your specific setup. If you are running into performance problems (slow tests, frequent hanging, etc) with one setting, try using the other.

## Stubbing

### Command

Given a recipe with shell guard:

```ruby
template '/tmp/foo.txt' do
  not_if 'grep text /tmp/foo.txt'
end
```

ChefSpec will raise an error like:

```text
Real commands are disabled. Unregistered command: `grep text /tmp/foo.txt`

You can stub this command with:

 stub_command("grep text /tmp/foo.txt").and_return(true)

============================================================
```

Just like the error message says, you must stub the command result. This can be done inside a `before` block or inside the `it` block, and the stubbing method accepts both a value or Ruby code. If provided a value, the result is static. If provided a Ruby block, the block is evaluated each time the search is called.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_command("grep text /tmp/foo.txt").and_return(true)
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_command("grep text /tmp/foo.txt") { rand(50)%2 == 0 }
  end
end
```

The stubbed command can also be passed as a regular expression, allowing multiple commands to be stubbed with one line.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_command(/(foo)|(bar)/).and_return(true)
  end
end
```

### Library Helpers

Given a library helper with a `has_bacon?` method:

```ruby
module Demo
  module Helper

    include Chef::Mixin::ShellOut

    def has_bacon?
      cmd = shell_out!('getent passwd bacon', {:returns => [0,2]})
      cmd.stderr.empty? && (cmd.stdout =~ /^bacon/)
    end
  end
end
```

Stub the output of the library helper. [Additional information](http://jtimberman.housepub.org/blog/2015/05/30/quick-tip-stubbing-library-helpers-in-chefspec/)

```ruby
before do
  allow_any_instance_of(Chef::Node).to receive(:has_bacon?).and_return(true)
end
```

### Data Bag & Data Bag Item

**NOTE** This is not required if you are using a ChefSpec server.

Given a recipe that executes a `data_bag` method:

```ruby
data_bag('users').each do |user|
  data_bag_item('users', user['id'])
end
```

ChefSpec will raise an error like:

```text
Real data_bags are disabled. Unregistered data_bag: data_bag(:users)

You can stub this data_bag with:

  stub_data_bag("users").and_return([])

============================================================
```

Just like the error message says, you must stub the result of the `data_bag` call. This can be done inside a `before` block or inside the `it` block, and the stubbing method accepts both a value or Ruby code. If provided a value, the result is static. If provided a Ruby block, the block is evaluated each time the search is called.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_data_bag('users').and_return([])
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_data_bag('users').and_return(['svargo', 'francis'])

    stub_data_bag_item('users', 'svargo').and_return({ ... })
    stub_data_bag_item('users', 'francis') { (ruby code) }
  end
end
```

If you are using **Encrypted Data Bag Items**, you'll need to dive into the RSpec layer and stub that class method instead:

```ruby
describe 'example::default' do
  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('users', 'svargo').and_return(...)
  end
end
```

### Search

**NOTE** This is not required if you are using a ChefSpec server.

Because ChefSpec is a unit-testing framework, it is recommended that all third-party API calls be mocked or stubbed. ChefSpec exposes a helpful RSpec macro for stubbing search results in your tests. If you converge a Chef recipe that implements a `search` call, ChefSpec will throw an error like:

```text
Real searches are disabled. Unregistered search: search(:node, 'name:hello')

You can stub this search with:

  stub_search(:node, 'name:hello') {  }

============================================================
```

Just like the error message says, you must stub the search result. This can be done inside a `before` block or inside the `it` block, and the stubbing method accepts both a value or Ruby code. If provided a value, the result is static. If provided a Ruby block, the block is evaluated each time the search is called.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_search(:node, 'name:hello').and_return([])
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_search(:node, 'name:hello') { (ruby_code) }
  end
end
```

### Ruby libraries (File, FileUtils, etc)

When stubbing core ruby libraries, users must be aware that there is no differentiation between your cookbook code that calls `File.exist?` and core chef code (e.g. the cookbook loader) that calls `File.exist?`. If you stub or setup an expectation without qualifying the arguments then you will stub that method for all core chef code as well. Also note that if you setup an expectation on a particular argument that invoking the method with any other argument will throw an unexpected argument error out of rspec, so you must setup an allowance using `.and_call_original` to avoid breaking core chef.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    # avoid breaking all of core chef wherever it calls File.exist? with other arguments
    allow(File).to receive(:exist?).and_call_original
  end

  it "tests something when /etc/myfile.txt does not exist" do
    # only setup an expectation on our file
    expect(File).to receive(:exist?).with("/etc/myfile.txt").and_return(false)
    [ ... test that the chef resource collection is constructed correctly in this case ... ]
  end
end
```

This is basic usage of rspec and not specific to chefspec. It applies to any class method in `File`, `Dir`, `FileUtils`, `IO` or any other ruby library. In general any time you `expect(Some::Symbol).to receive(:a_method).and_return(value)` you run the risk of breaking other code unless you isolate your mocking or expectation down to only the arguments which your code uses.

## Reporting

**NOTE: The coverage reporting feature is deprecated and will be removed in a future version. This documentation exists only for reference purposes.**

ChefSpec can generate a report of resources read over resources tested.

To generate the coverage report, add the following to your `spec_helper.rb` before you require any "Chef" code:

```ruby
require 'chefspec'
ChefSpec::Coverage.start!

# Existing spec_helper contents...
```

By default, that method will output helpful information to standard out:

```text
ChefSpec Coverage report generated...

  Total Resources:   6
  Touched Resources: 1
  Touch Coverage:    16.67%

Untouched Resources:

  package[git]               bacon/recipes/default.rb:2
  package[build-essential]   bacon/recipes/default.rb:3
  package[apache2]           bacon/recipes/default.rb:4
  package[libvirt]           bacon/recipes/default.rb:5
  package[core]              bacon/recipes/default.rb:6
```

By default, ChefSpec will test all cookbooks that are loaded as part of the Chef Client run. If you have a cookbook with many dependencies, this may be less than desirable. To restrict coverage reporting against certain cookbooks, `ChefSpec::Coverage` yields a block:

```ruby
ChefSpec::Coverage.start! do
  add_filter 'vendor/cookbooks'
end
```

The `add_filter` method accepts a variety of objects. For example:

```ruby
ChefSpec::Coverage.start! do
  # Strings are interpreted as file paths, with a forward anchor
  add_filter 'vendor/cookbooks'

  # Regular expressions must be escaped, but provide a nicer API for negative
  # back tracking
  add_filter /cookbooks\/(?!omnibus)/

  # Custom block filters yield a {Chef::Resource} object - if the block
  # evaluates to true, it will be filtered
  add_filter do |resource|
    # Bob's cookbook's are completely untested! Ignore them until he gets his
    # shit together.
    resource.source_file =~ /cookbooks\/bob-(.+)/
  end
end
```

For more complex scenarios, you can create a custom `Filter` object that inherits from `ChefSpec::Coverage::Filter` and implements the `matches?` method.

```ruby
class CustomFilter < ChefSpec::Coverage::Filter
  def initialize(arg1, arg2, █)
    # Create a custom initialization method, do some magic, etc.
  end

  def matches?(resource)
    # Custom matching logic in here - anything that evaluates to "true" will be
    # filtered.
  end
end

ChefSpec::Coverage.start! do
  add_filter CustomFilter.new('foo', :bar)
end
```

If you are using ChefSpec's Berkshelf plugin, a filter is automatically created for you. If you would like to ignore that filter, you can `clear` all the filters before defining your own:

```ruby
ChefSpec::Coverage.start! do
  filters.clear

  # Add your custom filters now
end
```

If you would like a different output format for the Coverage.report! output, you can specify one of the three built-in templates, or supply your own by calling the set_template in the `ChefSpec::Coverage` block:

```ruby
ChefSpec::Coverage.start! do
  set_template 'json.erb'
end
```

Provided templates are human.erb_(default)_, table.erb and json.erb, to supply a custom template, specify a relative(to run directory) or absolute path.

```ruby
ChefSpec::Coverage.start! do
  set_template '/opt/custom/templates/verbose.erb'
end
```

If you would like to add alternative reporting for the Coverage.report! ouput, you can supply your own by calling add_output in the `ChefSepc::Coverage` block: Note the reportOutput has the following items in it: total, touched, coverage and collections of untouched_resources and all_resources

```ruby
ChefSpec::Coverage.start! do
  add_output do |reportOutput|
    File.open( "coverage.json","w" ) do |f|
      f.puts(reportOutput[:total])
      f.puts(reportOutput[:touched])
      f.puts(reportOutput[:coverage])
      f.puts(reportOutput[:untouched_resources])
      f.puts(reportOutput[:all_resources])
    end
  end
end
```

Note the above example outputs the raw data without applying formatting.

## Mocking Out Environments

### ServerRunner

```ruby
ChefSpec::ServerRunner.new do |node, server|
  # Create the environment
  server.create_environment('staging', { default_attributes: { cookbook_attr: 'value' } })

  # Assign the environment to the node
  node.chef_environment = 'staging'
end
```

### SoloRunner

If you want to mock out `node.chef_environment`, you'll need to use RSpec mocks/stubs twice:

```ruby
let(:chef_run) do
  ChefSpec::SoloRunner.new do |node|
    # Create a new environment (you could also use a different :let block or :before block)
    env = Chef::Environment.new
    env.name 'staging'

    # Stub the node to return this environment
    allow(node).to receive(:chef_environment).and_return(env.name)

    # Stub any calls to Environment.load to return this environment
    allow(Chef::Environment).to receive(:load).and_return(env)
  end.converge('cookbook::recipe')
end
```

**There is probably a better/easier way to do this. If you have a better solution, please open an issue or Pull Request so we can make this less painful :)**

## Testing LWRPs

**WARNING** Cookbooks with dashes (hyphens) are difficult to test with ChefSpec because of how Chef classifies objects. We recommend naming cookbooks with underscores (`_`) instead of dashes (`-`).

ChefSpec overrides all providers to take no action (otherwise it would actually converge your system). This means that the steps inside your LWRP are not actually executed. If an LWRP performs actions, those actions are never executed or added to the resource collection.

In order to run the actions exposed by your LWRP, you have to explicitly tell the `Runner` to step into it:

```ruby
require 'chefspec'

describe 'foo::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['my_lwrp']).converge('foo::default')
  end

  it 'installs the foo package through my_lwrp' do
    expect(chef_run).to install_package('foo')
  end
end
```

**NOTE:** If your cookbook exposes LWRPs, it is highly recommended you also create a `libraries/matchers.rb` file as outlined below in the "Packaging Custom Matchers" section. **You should never `step_into` an LWRP unless you are testing it. Never `step_into` an LWRP from another cookbook!**

## Automatic Matchers

As of ChefSpec 7.1.0 there are "custom" matchers generated for all internal core-chef resources, along with any LWRPs/HWRPs/Custom Resources that are user-defined in cookbooks.

The matchers follow the standard custom of `<action>_<resource_name>` with the exception of the `create_if_missing` action which _also_ gets a `create_<resource_name>_if_missing` matcher.

Matchers should be wired up for the `resource_name` of the resource along with all define `provides` lines synonyms and any `action` methods or `allowed_actions`.

There should be little reason to package custom matchers in cookbooks any more, but the approach below still works if there are special matchers which cookbooks wish to expose which do not follow the automatically generated pattern.

## Packaging Custom Matchers

ChefSpec exposes the ability for cookbook authors to package custom matchers inside a cookbook so that other developers may take advantage of them in testing. This is done by creating a special library file in the cookbook named `matchers.rb`:

```ruby
# cookbook/libraries/matchers.rb

if defined?(ChefSpec)
  def my_custom_matcher(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(resource, action, resource_name)
  end
end
```

1. The entire contents of this file must be wrapped with the conditional clause checking if `ChefSpec` is defined.
2. Each matcher is actually a top-level method. The above example corresponds to the following RSpec test:

  ```ruby
  expect(chef_run).to my_custom_matcher('...')
  ```

3. `ChefSpec::Matchers::ResourceMatcher` accepts three parameters:

  1. The name of the resource to find in the resource collection (i.e. the name of the LWRP).
  2. The action that resource should receive.
  3. The value of the name attribute of the resource to find. (This is typically proxied as the value from the matcher definition.)

ChefSpec's built-in `ResourceMatcher` _should_ satisfy most common use cases for packaging a custom matcher with your LWRPs. However, if your cookbook is extending Chef core or is outside of the scope of a traditional "resource", you may need to create a custom matcher. For more information on custom matchers in RSpec, please [watch the Railscast on Custom Matchers](http://railscasts.com/episodes/157-rspec-matchers-macros) or look at some of the other custom matchers in ChefSpec's source code.

### Example

Suppose I have a cookbook named "motd" with a resource/provider "message".

```ruby
# motd/resources/message.rb
actions :write
default_action :write

attribute :message, name_attribute: true
```

```ruby
# motd/providers/message.rb
action :write do
  # ...
end
```

Chef will dynamically build the `motd_message` LWRP at runtime that can be used in the recipe DSL:

```ruby
motd_message 'my message'
```

You can package a custom ChefSpec matcher with the motd cookbook by including the following code in `libraries/matchers.rb`:

```ruby
# motd/libraries/matchers.rb
if defined?(ChefSpec)
  def write_motd_message(message)
    ChefSpec::Matchers::ResourceMatcher.new(:motd_message, :write, message)
  end
end
```

Other developers can write RSpec tests against your LWRP in their cookbooks:

```ruby
expect(chef_run).to write_motd_message('my message')
```

**Don't forget to include documentation in your cookbook's README noting the custom matcher and its API!**

As a caveat, if your custom LWRP uses a custom `provides` value as shown below (Chef 12+), you will need to package slightly different custom matchers:

```ruby
# motd/resources/message.rb
actions :write
default_action :write

provides :foobar

attribute :message, name_attribute: true
```

With a custom `provides` declaration, the resource is still inserted into the resource collection with its generic name; `provides` is just sugar for use in the recipe. As such, you will also need to introduce sugar into your custom matchers:

```ruby
# motd/libraries/matchers.rb
if defined?(ChefSpec)
  def write_foobar(message)
    ChefSpec::Matchers::ResourceMatcher.new(:motd_message, :write, message)
  end
end
```

Notice that we have changed the name of the method to match the "foobar" action, but the resource matcher definition remains unchanged. When the Chef run executes, the resource will be inserted into the collection as `motd_message`, even though it was given a custom provides.

## Writing Custom Matchers

If you are testing a cookbook that does not package its LWRP matchers, you can create your own following the same pattern as the "Packaging Custom Matchers" section. Simply, create a file at `spec/support/matchers.rb` and add your resource matchers:

```ruby
# spec/support/matchers.rb
def my_custom_matcher(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:resource, :action, resource_name)
end
```

Then require this file in your `spec_helper.rb` so the matcher can be used:

```ruby
require_relative 'support/matchers'
```

Please use this as a _temporary_ solution. Consider sending a Pull Request to the LWRP author(s) packaging the custom resource matchers (see previous section).

## Matchers for looking up custom resources

ChefSpec also provides a helper method to define a method on the Chef runner for locating a resource in the collection. This is helpful while asserting against custom resource notifications.

```ruby
# matchers.rb
ChefSpec.define_matcher :my_custom_resource
```

And then in your spec suite, you can obtain the custom resource for assertions:

```ruby
let(:chef_run) { ChefSpec::SoloRunner.converge('...') }

it 'notifies the thing' do
  custom = chef_run.my_custom_resource('name')
  expect(custom).to notify('service[apache2]').to(:restart).immediately
end
```

You can use this functionality to bundle lookup matchers with cookbooks, or to provide your own when the upstream cookbook doesn't include it.

## Expecting Exceptions

In Chef 11, custom formatters were introduced and ChefSpec uses a custom formatter to suppress Chef Client output. In the event of a convergence failure, ChefSpec will output the error message from the run to help you debug:

```text
================================================================================
Recipe Compile Error in apt_package/recipes/install.rb
================================================================================

RuntimeError
------------
RuntimeError

Cookbook Trace:
---------------
  .../apt_package/recipes/install.rb:1:in `from_file'
  .../apt_package/spec/install_spec.rb:4:in `block (2 levels) in <top (required)>'
  .../apt_package/spec/install_spec.rb:7:in `block (2 levels) in <top (required)>'

Relevant File Content:
----------------------
.../apt_package/recipes/install.rb:

  1>> raise RuntimeError
  2:
  3:  apt_package 'default_action'
```

This output is automatically silenced when using RSpec's `raise_error` matcher:

```ruby
let(:chef_run) { ChefSpec::SoloRunner.converge('cookbook::recipe') }

it 'raises an error' do
  expect {
    chef_run
  }.to raise_error
end
```

You can also assert that a particular error was raised. If the error matches the given type, the output is suppressed. If not, the test fails and the entire stack trace is presented.

```ruby
let(:chef_run) { ChefSpec::SoloRunner.converge('cookbook::recipe') }

it 'raises an error' do
  expect {
    chef_run
  }.to raise_error(RuntimeError)
end
```

## Testing Multiple Recipes

Even though ChefSpec is cookbook-centric, you can still converge multiple recipes in a single `ChefSpec::SoloRunner` instance. Given a cookbook "sandwich" with recipes "bacon", "lettuce" and "tomato":

```ruby
# cookbooks/sandwich/recipes/bacon.rb
package 'bacon'

# cookbooks/sandwich/recipes/lettuce.rb
package 'lettuce'

# cookbooks/sandwich/recipes/tomato.rb
package 'tomato'
```

```ruby
let(:chef_run) { ChefSpec::SoloRunner.converge('sandwich::bacon', 'sandwich::lettuce', 'sandwich::tomato') }
```

```ruby
expect(chef_run).to install_package('bacon')
expect(chef_run).to install_package('lettuce')
expect(chef_run).to install_package('tomato')
```

## Testing Roles

Roles can also be used in a single `ChefSpec::SoloRunner` instance. Given a cookbook "bacon" with a default recipe:

```ruby
# cookbooks/bacon/recipes/default.rb
package 'foo'
```

and a default attributes file:

```ruby
# cookbooks/bacon/attributes/default.rb
default['bacon']['temperature'] = 200
```

and a role "breakfast":

```ruby
# roles/breakfast.rb
default_attributes(
  'bacon' => {
    'temperature' => 150 # NOTE: This is different from the default value
  }
)
run_list([
  'recipe[bacon::default]'
])
```

You can test that the role is appropriately applied by telling the `ChefSpec::SoloRunner` to converge on the _role_ instead of a recipe:

```ruby
let(:chef_run) { ChefSpec::SoloRunner.converge('role[breakfast]') }
```

Assert that the run_list is properly expanded:

```ruby
expect(chef_run).to include_recipe('bacon::default')
```

Assert that the correct attribute is used:

```ruby
expect(chef_run.node['bacon']['temperature']).to eq(150)
```

**NOTE** If your roles live somewhere outside of the expected path, you must set `RSpec.config.role_path` to point to the directory containing your roles **before** invoking the `#converge` method!

```ruby
RSpec.configure do |config|
  config.role_path = '/var/my/roles' # global setting
end

# - OR -

ChefSpec::SoloRunner.new(role_path: '/var/my/roles') # local setting
```

## Faster Specs

ChefSpec aims to provide the easiest and simplest path for new users to write RSpec examples for Chef cookbooks. In doing so, it makes some sacrifices in terms of speed and agility of execution. In other words, ChefSpec favors "speed to develop" over "speed to execute". Many of these decisions are directly related to the way Chef dynamically loads resources at runtime.

If you understand how RSpec works and would like to see some significant speed improvements in your specs, you can use the `ChefSpec::Cacher` module inspired by [Juri Timošin](https://github.com/DracoAter). Simply convert all your `let` blocks to `cached`:

```ruby
# before
let(:chef_run) { ChefSpec::SoloRunner.new }

# after
cached(:chef_run) { ChefSpec::SoloRunner.new }
```

Everything else should work the same. Be advised, as the method name suggests, this will cache the results of your Chef Client Run for the **entire RSpec example**. This makes stubbing more of a challenge, since the node is already converged. For more information, please see [Juri Timošin's blog post on faster specs](http://dracoater.blogspot.com/2013/12/testing-chef-cookbooks-part-25-speeding.html) as well as the discussion in [#275](https://github.com/chefspec/chefspec/issues/275).

## Media & Third-party Tutorials

- [CustomInk's Testing Chef Cookbooks](http://technology.customink.com/blog/2012/08/03/testing-chef-cookbooks/)
- [Jake Vanderdray's Practical ChefSpec](http://files.meetup.com/1780846/ChefSpec.pdf)
- [Jim Hopp's excellent Test Driven Development for Chef Practitioners](http://www.youtube.com/watch?v=o2e0aZUAVGw)
- [Joshua Timberman's Starting ChefSpec Examples](http://jtimberman.housepub.org/blog/2013/05/09/starting-chefspec-example/)
- [Juri Timošin's post on faster specs](http://dracoater.blogspot.com/2013/12/testing-chef-cookbooks-part-25-speeding.html)
- [Seth Vargo's Chef recipe code coverage](https://sethvargo.com/chef-recipe-code-coverage/)
- [Seth Vargo's TDDing tmux talk](http://www.confreaks.com/videos/2364-mwrc2013-tdding-tmux)
- [Stephen Nelson Smith's Test-Driven Infrastructure with Chef](http://shop.oreilly.com/product/0636920030973.do)

## Development

1. Fork the repository from GitHub.
2. Clone your fork to your local machine:

  ```
  $ git clone git@github.com:USER/chefspec.git
  ```

3. Create a git branch

  ```
  $ git checkout -b my_bug_fix
  ```

4. **Write tests**

5. Make your changes/patches/fixes, committing appropriately

6. Run the tests: `bundle exec rake`

7. Push your changes to GitHub

8. Open a Pull Request

ChefSpec is on [Travis CI][travis] which tests against multiple Chef and Ruby versions.

If you are contributing, please see the [Contributing Guidelines](https://github.com/chefspec/chefspec/blob/master/CONTRIBUTING.md) for more information.

## License

MIT - see the accompanying [LICENSE](https://github.com/chefspec/chefspec/blob/master/LICENSE) file for details.

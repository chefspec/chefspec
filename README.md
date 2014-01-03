ChefSpec
========
[![Built on Travis](https://secure.travis-ci.org/sethvargo/chefspec.png?branch=master)](http://travis-ci.org/sethvargo/chefspec)
[![Gem Version](https://badge.fury.io/rb/chefspec.png)](http://badge.fury.io/rb/chefspec)
[![Dependency Status](https://gemnasium.com/sethvargo/chefspec.png)](https://gemnasium.com/sethvargo/chefspec)
[![Code Climate](https://codeclimate.com/github/sethvargo/chefspec.png)](https://codeclimate.com/github/sethvargo/chefspec)

ChefSpec is a unit testing framework for testing Chef cookbooks. ChefSpec makes it easy to write examples and get fast feedback on cookbook changes without the need for virtual machines or cloud servers.

ChefSpec runs your cookbook locally using Chef Solo without actually converging a node. This has two primary benefits:

- It's really fast!
- Your tests can vary node attributes, operating systems, and search results to assert behavior under varying conditions.


What people are saying
----------------------
> I just wanted to drop you a line to say "HELL YES!" to ChefSpec. - [Joe Goggins](https://twitter.com/jgoggins)

> OK chefspec is my new best friend. Delightful few hours working with it. - [Michael Ivey](https://twitter.com/ivey)

**Chat with us - [#chefspec](irc://irc.freenode.net/chefspec) on Freenode**


Important Notes
---------------
- **ChefSpec 3 requires Chef 11+! Please use the 2.x series for Chef 9 & 10 compatibility.**
- **This documentation corresponds to the master branch, which may be unreleased. Please check the README of the latest git tag or the gem's source for your version' documentation!**
- **Each resource matcher is self-documented using [Yard](http://rubydoc.info/github/sethvargo/chefspec) and has a corresponding aruba test from the [examples directory](https://github.com/sethvargo/chefspec/tree/master/examples).**
- **ChefSpec 3.0 requires Ruby 1.9 or higher!**

If you are migrating from ChefSpec v2.0.0, you should require the deprecations module after requiring `chefspec`:

```ruby
# spec_helper.rb
require 'chefspec'
require 'chefspec/deprecations'
```

After you have converted your specs, you can safely remove the deprecations module.


Writing a Cookbook Example
--------------------------
If you want `knife` to automatically generate spec stubs for you, install [knife-spec](https://github.com/sethvargo/knife-spec).

Given an extremely basic Chef recipe that just installs an operating system package:

```ruby
package 'foo'
```

the associated ChefSpec test might look like:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs foo' do
    expect(chef_run).to install_package('foo')
  end
end
```

Let's step through this file to see what is happening:

1. At the top of the spec file we require the chefspec gem. This is required so that our custom matchers are loaded. In larger projects, it is common practice to create a file named "spec_helper.rb" and include ChefSpec and perform other setup tasks in that file.
1. The `describe` keyword is part of RSpec and indicates that everything nested beneath is describing the `example::default` recipe. The convention is to have a separate spec for each recipe in your cookbook.
1. The `let` block on creates the `ChefSpec:Runner` and then does a fake Chef run with the run_list of `example::default`. Any subsequent examples can then refer to `chef_run` in order to make assertions about the resources that were created during the mock converge.
1. The `described_recipe` macro is a ChefSpec helper method that infers the recipe from the `describe` block. Alternatively you could specify the recipe directly.
1. The `it` block is an example specifying that the `foo` package is installed. Normally you will have multiple `it` blocks per recipe, each making a single assertion.


Configuration
-------------
ChefSpec exposes a configuration layer at the global level and at the `Runner` level. The following settings are available:

```ruby
RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks (default: [inferred from
  # the location of the calling spec file])
  config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles (default: [ascending search])
  config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :debug

  # Specify the path to a local JSON file with Ohai data (default: nil)
  config.path = 'ohai.json'

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'ubuntu'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '12.04'
end
```

Values specified at the initialization of the `Runner` merge and take precedence over the global settings:

```ruby
# Override only the operating system version (platform is still "ubuntu" from above)
ChefSpec::Runner.new(version: '10.04')

# Use a different operating system platform and version
ChefSpec::Runner.new(platform: 'centos', version: '5.4')

# Specify a different cookbook_path
ChefSpec::Runner.new(cookbook_path: '/var/my/other/path', role_path: '/var/my/roles')

# Add debug log output
ChefSpec::Runner.new(log_level: :debug).converge(described_recipe)
```

**NOTE** You do not _need_ to specify a platform and version. However, some cookbooks may rely on [Ohai](http://github.com/opscode/ohai) data that ChefSpec cannot not automatically generate. Specifying the `platform` and `version` keys instructs ChefSpec to load stubbed Ohai attributes from another platform using [fauxhai](https://github.com/customink/fauxhai).

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

**NOTE** In order to test the cookbook in the current working directory, you
have to write your `Cheffile` like this:

```ruby
# Cheffile
site 'http://community.opscode.com/api/v1'

cookbook 'name_of_your_cookbook', path: '.'
```


Running Specs
-------------
ChefSpec is actually a very large RSpec extension, so you can run your tests using the RSpec CLI:

```bash
$ rspec
```

You can also specify a specific spec to run and various RSpec command line options:

```bash
$ rspec spec/unit/recipes/default_spec.rb --color
```

For more information on the RSpec CLI, please see the [documentation](https://relishapp.com/rspec/rspec-core/docs/command-line).


Making Assertions
-----------------
ChefSpec asserts that resource actions have been performed. In general, ChefSpec follows the following pattern:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does something' do
    expect(chef_run).to ACTION_RESOURCE(NAME)
  end
end
```

where:

- _ACTION_ - the action on the resource (e.g. `install`)
- _RESOURCE_ - the name of the resource (e.g. `package`)
- _NAME_ - the name attribute for the resource (e.g. `apache2`)

Here's a more concrete example:

```ruby
require 'chefspec'

describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'does something' do
    expect(chef_run).to install_package('apache2')
  end
end
```

This test is asserting that the Chef run will have a _package_ resource with the name _apache2_ with an action of _install_.

ChefSpec includes matchers for all of Chef's core resources using the above schema. Each resource matcher is self-documented using [Yard](http://rubydoc.info/github/sethvargo/chefspec) and has a corresponding cucumber test from the [examples directory](https://github.com/sethvargo/chefspec/tree/master/examples).

Additionally, ChefSpec includes the following helpful matchers. They are also [documented in Yard](http://rubydoc.info/github/sethvargo/chefspec), but they are included here because they do not follow the "general pattern".

##### include_recipe
Assert that the Chef run included a recipe from another cookbook

```ruby
expect(chef_run).to include_recipe('other_cookbook::recipe')
```

##### notify
Assert that a resource notifies another in the Chef run

```ruby
resource = chef_run.template('/etc/foo')
expect(resource).to notify('service[apache2]').to(:restart)
```

##### render_file
Assert that the Chef run renders a file (with optional content); this will match `cookbook_file`, `file`, and `template` resources and can also check the resulting content

```ruby
expect(chef_run).to render_file('/etc/foo')
expect(chef_run).to render_file('/etc/foo').with_content('This is content')
expect(chef_run).to render_file('/etc/foo').with_content(/regex works too.+/)
```

Additionally, it is possible to assert which [Chef phase of execution](http://docs.opscode.com/essentials_nodes_chef_run.html) a resource is created. Given a resource that is installed at compile time using `run_action`:

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

**For more complex examples, please see the [examples directory](https://github.com/sethvargo/chefspec/tree/master/examples) or the [Yard documentation](http://rubydoc.info/github/sethvargo/chefspec).**


Setting node Attributes
-----------------------
Node attribute can be set when creating the `Runner`. The initializer yields a block that gives full access to the node object:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['cookbook']['attribute'] = 'hello'
    end.converge(described_recipe)
  end
end
```

The `node` that is returned is actually a [`Chef::Node`](http://docs.opscode.com/essentials_node_object.html) object.

To set an attribute within a specific test, set the attribute in the `it` block and then **(re-)converge the node**:

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new } # Notice we don't converge here

  it 'performs the action' do
    chef_run.node.set['cookbook']['attribute'] = 'hello'
    chef_run.converge(described_recipe) # The converge happens inside the test

    expect(chef_run).to do_something
  end
end
```


Using Chef Zero
---------------
By default, ChefSpec runs in Chef Solo mode. As of ChefSpec v3.1.0, you can ask ChefSpec to create an in-memory Chef Server during testing using [ChefZero](https://github.com/jkeiser/chef-zero). This is especially helpful if you need to support searching or data bags.

To use the ChefSpec server, simply require the module in your `spec_helper`:

```ruby
# spec_helper.rb
require 'chefspec'
require 'chefspec/server'
```

This will automatically create a Chef server, synchronize all the cookbooks in your `cookbook_path`, and wire all the internals of Chef together. Recipe calls to `search`, `data_bag` and `data_bag_item` will now query the ChefSpec server.

### DSL
The ChefSpec server includes a collection of helpful DSL methods for populating data into the Chef Server.

Create a client:

```ruby
ChefSpec::Server.create_client('my_client', { admin: true })
```

Create a data bag (and items):

```ruby
ChefSpec::Server.create_data_bag('my_data_bag', {
  'item_1' => {
    'password' => 'abc123'
  },
  'item_2' => {
    'password' => 'def456'
  }
})
```

Create an environment:

```ruby
ChefSpec::Server.create_environment('my_environment', { description: '...' })
```

Create a node:

```ruby
ChefSpec::Server.create_node('my_node', { run_list: ['...'] })
```

You may also be interested in the `stub_node` macro, which will create a new `Chef::Node` object and accepts the same parameters as the Chef Runner and a Fauxhai object:

```ruby
www = stub_node(platform: 'ubuntu', version: '12.04') do |node|
        node['fqdn'] = 'www1.example.com'
      end

# `www` is now a local Chef::Node object you can use in your test. To push this
# node to the server, call `create_node`:

ChefSpec::Server.create_node('www', www)
```

Create a role:

```ruby
ChefSpec::Server.create_role('my_role', { default_attributes: {} })

# The role now exists on the Chef Server, you can add it to a node's run_list
# by adding it to the `converge` block:
let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe, 'role[my_role]') }
```

**NOTE** The ChefSpec server is empty at the start of each example to avoid interdependent tests. You can use `before` blocks to load data before each test.


Stubbing
--------
### Command
Given a recipe with shell guard:

```ruby
template '/tmp/foo.txt' do
  not_if 'grep /tmp/foo.txt text'
end
```

ChefSpec will raise an error like:

```text
Real commands are disabled. Unregistered command: `grep /tmp/foo.txt text`

You can stub this command with:

 stub_command("grep /tmp/foo.txt text").and_return(true)

============================================================
```

Just like the error message says, you must stub the command result. This can be done inside a `before` block or inside the `it` block, and the stubbing method accepts both a value or Ruby code. If provided a value, the result is static. If provided a Ruby block, the block is evaluated each time the search is called.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  before do
    stub_command("grep /tmp/foo.txt text").and_return(true)
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  before do
    stub_command("grep /tmp/foo.txt text") { rand(50)%2 == 0 }
  end
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

ChefSpec will rails an error like:

```text
Real data_bags are disabled. Unregistered data_bag: data_bag(:users)

You can stub this data_bag with:

  stub_data_bag("users").and_return({})

============================================================
```

Just like the error message says, you must stub the result of the `data_bag` call. This can be done inside a `before` block or inside the `it` block, and the stubbing method accepts both a value or Ruby code. If provided a value, the result is static. If provided a Ruby block, the block is evaluated each time the search is called.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  before do
    stub_data_bag('users').and_return([])
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  before do
    stub_data_bag('users').and_return([
      { id: 'svargo' },
      { id: 'francis' }
    ])

    stub_data_bag_item('users', 'svargo').and_return({ ... })
    stub_data_bag_item('users', 'francis') { (ruby code) }
  end
end
```

### Search
**NOTE** This is not required if you are using a ChefSpec server.

Because ChecSpec is a unit-testing framework, it is recommended that all third-party API calls be mocked or stubbed. ChefSpec exposes a helpful RSpec macro for stubbing search results in your tests. If you converge a Chef recipe that implements a `search` call, ChefSpec will throw an error like:

```text
Real searches are disabled. Unregistered search: search(:node, 'name:hello')

You can stub this search with:

  stub_search(:node, 'name:hello') {  }

============================================================
```

Just like the error message says, you must stub the search result. This can be done inside a `before` block or inside the `it` block, and the stubbing method accepts both a value or Ruby code. If provided a value, the result is static. If provided a Ruby block, the block is evaluated each time the search is called.

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  before do
    stub_search(:node, 'name:hello').and_return([])
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::Runner.new }

  before do
    stub_search(:node, 'name:hello') { (ruby_code) }
  end
end
```

Reporting
---------
ChefSpec attempts to generate a report of resources read over resources tested. Please note, this feature is currently in beta phases and may not be 100% accurate. That being said, it's currently the only code coverage tool available for Chef recipes.

To generate the coverage report, add the following the the **very end** of your `spec_helper.rb`:

```ruby
# Existing things...

at_exit { ChefSpec::Coverage.report! }
```

By default, that method will output helpful information to standard out:

```text
ChefSpec Coverage report generated at '.coverage/results.json':

  Total Resources:   6
  Touched Resources: 1
  Touch Coverage:    16.67%

Untouched Resources:

  package[git]: bacon/recipes/default.rb:2
  package[build-essential]: bacon/recipes/default.rb:3
  package[apache2]: bacon/recipes/default.rb:4
  package[libvrt]: bacon/recipes/default.rb:5
  package[core]: bacon/recipes/default.rb:6
```

It also outputs a machine-parsable JSON file at `.coverage/results.json`. This file can be read by your CI server to determine changes in code coverage. We recommend adding the `.coverage` directory to your `.gitignore` to avoid committing it to git.

You can configure both the announcing behavior and JSON file. Please see the YARD documentaion for more information.

If you want to restrict coverage reporting only against certain cookbook directories, you can do it using filters. For example, to include only the site-cookbooks directory for coverage reporting, add the following line in your ```spec/spec_helper.rb```

```ruby
 ChefSpec::Coverage.filters << File.expand_path('../../site-cookbooks', __FILE__)
```


Mocking Out Environments
------------------------
If you want to mock out `node.chef_environment`, you'll need to use RSpec mocks/stubs twice:

```ruby
let(:chef_run) do
  ChefSpec::Runner.new do |node|
    # Create a new environment (you could also use a different :let block or :before block)
    env = Chef::Environment.new
    env.name 'staging'

    # Stub the node to return this environment
    node.stub(:chef_environment).and_return(env.name)

    # Stub any calls to Environment.load to return this environment
    Chef::Environment.stub(:load).and_return(env)
  end.converge('cookbook::recipe')
end
```

**There is probably a better/easier way to do this. If you have a better solution, please open an issue or Pull Request so we can make this less painful :)**


Testing LWRPs
-------------
**WARNING** Cookbooks with dashes (hyphens) are difficult to test with ChefSpec because of how Chef classifies objects. We recommend naming cookbooks with underscores (`_`) instead of dashes (`-`).

ChefSpec overrides all providers to take no action (otherwise it would actually converge your system). This means that the steps inside your LWRP are not actually executed. If an LWRP performs actions, those actions are never executed or added to the resource collection.

In order to run the actions exposed by your LWRP, you have to explicitly tell the `Runner` to step into it:

```ruby
require 'chefspec'

describe 'foo::default' do
  let(:chef_run) { ChefSpec::Runner.new(step_into: ['my_lwrp']).converge('foo::default') }

  it 'installs the foo package through my_lwrp' do
    expect(chef_run).to install_package('foo')
  end
end
```

**NOTE:** If your cookbook exposes LWRPs, it is highly recommended you also create a `libraries/matchers.rb` file as outlined below in the "Packaging Custom Matchers" section. **You should never `step_into` an LWRP unless you are testing it. Never `step_into` an LWRP from another cookbook!**


Packaging Custom Matchers
-------------------------
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

#### Example
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

**Don't forget to include documentation in your cookbook's README noting the custom matcher and it's API!**


Writing Custom Matchers
-----------------------
If you are testing a cookbook that does not package it's LWRP matchers, you can create your own following the same pattern as the "Packaging Custom Matchers" section. Simply, create a file at `spec/support/matchers.rb` and add your resource matchers:

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


Expecting Exceptions
--------------------
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
let(:chef_run) { ChefSpec::Runner.new.converge('cookbook::recipe') }

it 'raises an error' do
  expect {
    chef_run
  }.to raise_error
end
```

You can also assert that a particular error was raised. If the error matches the given type, the output is suppressed. If not, the test fails and the entire stack trace is presented.

```ruby
let(:chef_run) { ChefSpec::Runner.new.converge('cookbook::recipe') }

it 'raises an error' do
  expect {
    chef_run
  }.to raise_error(RuntimeError)
end
```

Testing Roles
-------------
Even though ChefSpec is cookbook-centric, you can still converge multiple recipes and roles in a single `ChefSpec::Runner` instance. Given a cookbook "bacon" with a default recipe:

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

You can test that the role is appropriately applied by telling the `ChefSpec::Runner` to converge on the _role_ instead of a recipe:

```ruby
let(:chef_run) { ChefSpec::Runner.new.converge('role[breakfast]') }
```

Assert that the run_list is properly expanded:

```ruby
expect(chef_run).to include_recipe('bacon::default')
```

Assert that the correct attribute is used:

```ruby
expect(runner.node['bacon']['temperature']).to eq(150)
```

**NOTE** If your roles live somewhere outside of the expected path, you must set `RSpec.config.role_path` to point to the directory containing your roles **before** invoking the `#converge` method!

```ruby
RSpec.configure do |config|
  config.role_path = '/var/my/roles' # global setting
end

# - OR -

ChefSpec::Runner.new(role_path: '/var/my/roles') # local setting
```


Faster Specs
------------
ChefSpec aims to provide the easiest and simplest path for new users to write RSpec examples for Chef cookbooks. In doing so, it makes some sacrifies in terms of speed and agility of execution. In other words, ChefSpec favors "speed to develop" over "speed to execute". Many of these decisions are directly related to the way Chef dynamically loads resources at runtime.

If you understand how RSpec works and would like to see some significant speed improvements in your specs, you can use the `ChefSpec::Cacher` module inspired by [Juri Timošin](https://github.com/DracoAter). Just require the cacher module in your spec helper.

```ruby
# spec_helper.rb
require 'chefspec/cacher'
```

Next, convert all your `let` blocks to `cached`:

```ruby
# before
let(:chef_run) { ChefSpec::Runer.new }

# after
cached(:chef_run) { ChefSpec::Runner.new }
```

Everything else should work the same. Be advised, as the method name suggests, this will cache the results of your Chef Client Run for the **entire RSpec example**. This makes stubbing more of a challenge, since the node is already converged. For more information, please see [Juri Timošin's blog post on faster specs](http://dracoater.blogspot.com/2013/12/testing-chef-cookbooks-part-25-speeding.html) as well as the discussion in [#275](https://github.com/sethvargo/chefspec/issues/275).


Media & Third-party Tutorials
-----------------------------
- [CustomInk's Testing Chef Cookbooks](http://technology.customink.com/blog/2012/08/03/testing-chef-cookbooks/)
- [Jake Vanderdray's Practical ChefSpec](http://files.meetup.com/1780846/ChefSpec.pdf)
- [Jim Hopp's excellent Test Driven Development for Chef Practitioners](http://www.youtube.com/watch?v=o2e0aZUAVGw)
- [Joshua Timberman's Starting ChefSpec Examples](http://jtimberman.housepub.org/blog/2013/05/09/starting-chefspec-example/)
- [Juri Timošin's post on faster specs](http://dracoater.blogspot.com/2013/12/testing-chef-cookbooks-part-25-speeding.html)
- [Seth Vargo's Chef recipe code coverage](https://sethvargo.com/chef-recipe-code-coverage/)
- [Seth Vargo's TDDing tmux talk](http://www.confreaks.com/videos/2364-mwrc2013-tdding-tmux)
- [Stephen Nelson Smith's Test-Driven Infrastructure with Chef](http://shop.oreilly.com/product/0636920030973.do)


Development
-----------
1. Fork the repository from GitHub.
2. Clone your fork to your local machine:

        $ git clone git@github.com:USER/chefspec.git

3. Create a git branch

        $ git checkout -b my_bug_fix

4. **Write tests**
5. Make your changes/patches/fixes, committing appropriately
6. Run the tests: `bundle exec rake`
7. Push your changes to GitHub
8. Open a Pull Request

ChefSpec is on [Travis CI](http://travis-ci.org/sethvargo/chefspec) which tests against multiple Chef and Ruby versions.

If you are contributing, please see the [Contributing Guidelines](https://github.com/sethvargo/chefspec/blob/master/CONTRIBUTING.md) for more information.


License
-------
MIT - see the accompanying [LICENSE](https://github.com/sethvargo/chefspec/blob/master/LICENSE) file for details.

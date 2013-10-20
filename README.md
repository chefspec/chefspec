ChefSpec
========
[![Built on Travis](https://secure.travis-ci.org/acrmp/chefspec.png?branch=master)](http://travis-ci.org/acrmp/chefspec)
[![Gem Version](https://badge.fury.io/rb/chefspec.png)](http://badge.fury.io/rb/chefspec)
[![Dependency Status](https://gemnasium.com/acrmp/chefspec.png)](https://gemnasium.com/acrmp/chefspec)
[![Code Climate](https://codeclimate.com/github/acrmp/chefspec.png)](https://codeclimate.com/github/acrmp/chefspec)

ChefSpec is a unit testing framework for testing Chef cookbooks. ChefSpec makes it easy to write examples and get fast feedback on cookbook changes without the need for virtual machines or cloud servers.

ChefSpec runs your cookbook locally using Chef Solo without actually converging a node. This has two primary benefits:

- It's really fast!
- Your tests can vary node attributes, operating systems, and search results to assert behavior under varying conditions.


Important Notes
---------------
- **This documentation corresponds to the master branch, which may be unreleased. Please check the README of the latest git tag or the gem's source for your version' documentation!**
- **Each resource matcher is self-documented using [Yard](http://rubydoc.info/github/acrmp/chefspec) and has a corresponding aruba test from the [examples directory](https://github.com/acrmp/chefspec/tree/master/examples).**
- **ChefSpec 3.0 requires Ruby 1.9 or higher!**


Writing a Cookbook Example
--------------------------
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
  config.cookbook_path = '/var/cookbooks'

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

Values specified at the initalization of the `Runner` merge and take precedence over the global settings:

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

**Note:** You do not _need_ to specify a platform and version. However, some cookbooks may rely on [Ohai](http://github.com/opscode/ohai) data that ChefSpec cannot not automatically generate. Specifying the `platform` and `version` keys instructs ChefSpec to load stubbed Ohai attributes from another platform using [fauxhai](https://github.com/customink/fauxhai).

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
_There is not currently librarian integration, but we would welcome a community patch!_


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

ChefSpec includes matchers for all of Chef's core resources using the above schema. Each resource matcher is self-documented using [Yard](http://rubydoc.info/github/acrmp/chefspec) and has a corresponding cucumber test from the [examples directory](https://github.com/acrmp/chefspec/tree/master/examples).

Additionally, ChefSpec includes the following helpful matchers. They are also [documented in Yard](http://rubydoc.info/github/acrmp/chefspec), but they are included here because they do not follow the "general pattern".

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

Additionally, it is possible to assert which [Chef phase of execution](http://docs.opscode.com/essentials_nodes_chef_run.html) a resouce is created. Given a resource that is installed at compile time using `run_action`:

```ruby
package('apache2').run_action(:install)
```

You can assert that this package is installed during runtime using the `.at_compile_time` predicate on the resource matcher:

```ruby
expect(chef_run).to install_package('apache2').at_compile_time
```

Simiarly, you can assert that a resource is executed during convergence time:

```ruby
expect(chef_run).to install_package('apache2').at_converge_time
```

Since "converge time" is the default behavior for all recipes, this test might be redundant and the predicate could be dropped depending on your situation.

**For more complex examples, please see the [examples directory](https://github.com/acrmp/chefspec/tree/master/examples) or the [Yard documentation](http://rubydoc.info/github/acrmp/chefspec).**


Setting node Attributes
-----------------------
Node attribute can be set when creating the `Runner`. The initializer yields a block that gives full access to the node object:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::ChefRunner.new do |node|
      node.set['cookbook']['attribute'] = 'hello'
    end.converge(described_recipe)
  end
end
```

The `node` that is returned is actually a [`Chef::Node`](http://docs.opscode.com/essentials_node_object.html) object.

To set an attribute within a specific test, set the attribute in the `it` block and then **(re-)converge the node**:

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new } # Notice we don't converge here

  it 'performs the action' do
    chef_run.node.set['cookbook']['attribute'] = 'hello'
    chef_run.converge(described_recipe) # The converge happens inside the test

    expect(chef_run).to do_something
  end
end
```


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
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before do
    stub_command("grep /tmp/foo.txt text").and_return(true)
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before do
    stub_command("grep /tmp/foo.txt text") { rand(50)%2 == 0 }
  end
end
```

### Data Bag & Data Bag Item
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
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before do
    stub_data_bag('users').and_return([])
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

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
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before do
    stub_search(:node, 'name:hello').and_return([])
  end
end
```

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  before do
    stub_search(:node, 'name:hello') { (ruby_code) }
  end
end
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

**Please read the caveats on custom LWRPs in the wiki before testing your LWRPs!**

**You should never `step_into` an LWRP unless you are testing it. Never `step_into` an LWRP from another cookbook!**


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

You can package a custom ChefSpec matcher with the motd cookbook by including the following code in `libraries/matcher.rb`:

```ruby
# motd/libraries/matcher.rb
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
If you are testing a cookbook that does not package it's LWRP matchers, you can create your own following the same pattern as above. Create a file at `spec/support/matchers.rb` and add your resource matchers:

```ruby
# spec/support/matchers.rb
def my_custom_matcher(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:resource, :action, resource_name)
end
```

Please use this as a _temporary_ solution. Consider sending a Pull Request to the LWRP author(s) packaging the custom resource matchers (see previous section).


Expecting Exceptions
--------------------
In Chef 11, custom formatters were introduced and ChefSpec uses a custom formatter to supress Chef Client output. In the event of a convergence failure, ChefSpec will output the error message from the run to help you debug:

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

**NOTE:** If your roles live somewhere outside of the expected path, you must set `RSpec.config.role_path` to point to the directory containing your roles **before** invoking the `#converge` method!

```ruby
RSpec.configure do |config|
  config.role_path = '/var/my/roles' # global setting
end

# - OR -

ChefSpec::Runner.new(role_path: '/var/my/roles') # local setting
```


Videos
------
- Jim Hopp's excellent [Test Driven Development for Chef Practitioners](http://www.youtube.com/watch?v=o2e0aZUAVGw)
- Seth Vargo's [TDDing tmux talk](http://www.confreaks.com/videos/2364-mwrc2013-tdding-tmux) Using ChefSpec with Guard.


Development
-----------
1. Fork the repository from GitHub.
2. Clone your fork to your local machine:

        $ git clone git@github.com:USER/chefspec.git

3. Create a git branch

        $ git checkout -b my_bug_fix

4. **Write tests**
5. Make your changes/patches/fixes, committing appropiately
6. Run the tests: `bundle exec rake`
7. Push your changes to GitHub
8. Open a Pull Request

ChefSpec is on [Travis CI](http://travis-ci.org/acrmp/chefspec) which tests against multiple Chef and Ruby versions.

If you are contributing, please see the [Contributing Guidelines](https://github.com/acrmp/chefspec/blob/master/CONTRIBUTING.md) for more information.


License
-------
MIT - see the accompanying [LICENSE](https://github.com/acrmp/chefspec/blob/master/LICENSE) file for details.

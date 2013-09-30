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
- **Each resource matcher is self-documented using Yard and has a corresponding cucumber test from the `examples` directory.**


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


Setting node Attributes
-----------------------
You can set node attribtues when creating the `ChefSpec::Runner` by passing a block to the initializer:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::ChefRunner.new do |node|
      node.set['cookbook']['attribute'] = 'hello'
    end
  end
end
```

This will set the node attribute for all Chef runners. If you only need to set an attribute for a specific test, you can set that attribute in the `it` block:

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new }

  it 'performs the action' do
    chef_run.node.set['cookbook']['attribute'] = 'hello'
    chef_run.converge(described_recipe)
  end
end
```

Notice that, unlike the previous examples, here were are converging the node inside the `it` block, rather than the `let` block. This is because if we converge the node _before_ setting those node attributes, the Chef Runner will not use the resources (because it's already been run). In other words, this won't work:

```ruby
# !!! Don't do this
describe 'example::default' do
  it 'performs the action' do
    chef_run = ChefSpec::Runer.new.converge(described_recipe)
    chef_run.node.set['cookbook']['attribute'] = 'hello'
    chef_run.converge(described_recipe)
  end
end
```


Ohai Attributes
---------------
When you converge a real node using Chef, a large number of attributes are pre-populated by Chef which runs [Ohai](http://github.com/opscode/ohai) to discover information about
the node on which it's running. Unfortunately, in ChefSpec, we cannot effectively rely on the results from Ohai, because the target system may not match the local one. Many cookboos rely on Ohai attributes, especially those that use platform conditionals and networking attributes. You can mock these attributes like in the previous section:

```ruby
describe 'example::default' do
  let(:chef_run) do
    ChefSpec::ChefRunner.new do |node|
      node.automatic_attrs['platform'] = 'Ubuntu'
      node.automatic_attrs['platform_version'] = '12.04'
    end
  end
end
```

However, this can quickly become cumbersome with large numbers of node attributes. Fortunately, you can tell ChefSpec to automatically generate Ohai attributes for another platform by specifying the `platform` and `version` keys to the `ChefSpec::Runner`:

```ruby
describe 'example::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') }
end
```

Under the hood, ChefSpec uses [fauxhai](https://github.com/customink/fauxhai) to populate these node attributes. You can also pass the path to a local JSON file instead. Please see fauxhai's README for a full list of configuration options. For more on fauxhai [check out this blog post](http://technology.customink.com/blog/2012/08/03/testing-chef-cookbooks/) from CustomInk.


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
ChefSpec also requires you stub the results of `data_bag` and `data_bag_item` calls. Given a recipe that executes a `data_bag` method:

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

- *ACTION* - the action on the resource (e.g. `install`)
- *RESOURCE* - the name of the resource (e.g. `package`)
- *NAME* - the name attribute for the resource (e.g. `apache2`)

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

ChefSpec includes matchers for all of Chef's core resources using the above schema. Each resource matcher is self-documented using Yard and has a corresponding cucumber test from the `examples` directory. Additionally, ChefSpec includes the following matchers:

- `include_recipe` - asserts that the Chef run included a recipe from another cookbook

```ruby
expect(chef_run).to include_recipe('other_cookbook:recipe')
```

- `notify` - asserts that a resource notifies another in the Chef run

```ruby
resource = chef_run.template('/etc/foo')
expect(resource).to notify('service[apache2]').to(:restart)
```

- `render_file` - assert that the Chef run renders a file (with optional content); this will match `cookbook_file`, `file`, and `template` resources and can also check the resulting content

```ruby
expect(chef_run).to render_file('/etc/foo')
expect(chef_run).to render_file('/etc/foo').with_content('This is content')
expect(chef_run).to render_file('/etc/foo').with_content(/regex works too.+/)
```


Varying the Cookbook Path
-------------------------
By default ChefSpec will infer the `cookbook_path` from the location of the calling spec. However if you want to use a different path, or append additional paths, you can pass it in as an argument to the `Runner` constructor:

```ruby
require 'chefspec'

describe 'foo::default' do
  let(:chef_run) { ChefSpec::Runner.new(cookbook_path: '/some/path').converge('foo::default') }

  it 'installs the foo package' do
    expect(chef_run).to install_package('foo')
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


Testing LWRPs
-------------
By default ChefSpec will override all resources to take no action. This means that the steps inside your LWRP are not actually executed. If an LWRP performs actions, those actions are never executed, or added to the resource collection.

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

**You should never `step_into` an LWRP unless you are testing it. Never `step_into` an LWRP from another cookbook!**


Packaging LWRP Matchers
-----------------------
ChefSpec exposes the ability for cookbook authors to package custom matchers in a cookbooks so other developers may take advantage of them in testing. This is done by creating a special library file in the cookbook named `matcher.rb`:

```ruby
# cookbook/libraries/matcher.rb

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

ChefSpec's built-in `ResourceMatcher` _should_ satisfy most common use cases for custom LWRPs and matchers. However, if your cookbook is extending Chef core or is outside of the scope of traditional resource testing, you may need to create a custom matcher. For more information on custom matchers in RSpec, please [watch the Railscast on Custom Matchers](http://railscasts.com/episodes/157-rspec-matchers-macros).

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

This allows developers to write RSpec tests against your LWRP in their own cookbooks:

```ruby
expect(chef_run).to write_motd_message('my message')
```

_Don't forget to include documentation in your cookbook's README noting the custom matcher and it's API!_


Silent Output
-------------
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

4. Make your changes/patches/fixes, committing appropiately
5. **Write tests**
6. Run the tests: `bundle exec rake`
7. Push your changes to GitHub
8. Open a Pull Request

ChefSpec is on [Travis CI](http://travis-ci.org/acrmp/chefspec) which tests against multiple Chef and Ruby versions.

If you are contributing, please see the [Contributing Guidelines](https://github.com/acrmp/chefspec/blob/master/CONTRIBUTING.md) for more information.


License
-------
MIT - see the accompanying [LICENSE](https://github.com/acrmp/chefspec/blob/master/LICENSE) file for details.

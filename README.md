# ChefSpec

[![Gem Version](https://badge.fury.io/rb/chefspec.svg)](https://badge.fury.io/rb/chefspec)
[![Build Status](https://travis-ci.org/chefspec/chefspec.svg?branch=master)](https://travis-ci.org/chefspec/chefspec) 
[![CI](https://github.com/chefspec/chefspec/actions/workflows/ci.yml/badge.svg)](https://github.com/chefspec/chefspec/actions/workflows/ci.yml)

ChefSpec is a unit testing framework for testing Chef cookbooks. ChefSpec makes it easy to write examples and get fast feedback on cookbook changes without the need for virtual machines or cloud servers.

ChefSpec runs your cookbooks locally while skipping making actual changes. This has two primary benefits:

- It's really fast!
- Your tests can vary node attributes, operating systems, and other system data to assert behavior under varying conditions.

## Important Notes

- **ChefSpec requires Ruby 2.5 or later and Chef 15 or later!**
- **This documentation corresponds to the master branch, which may be unreleased. Please check the README of the latest git tag or the gem's source for your version's documentation!**

**ChefSpec aims to maintain compatibility with at least the two most recent minor versions of Chef.** If you are running an older version of Chef it may work, or you will need to run an older version of ChefSpec.

As a general rule, if it is tested in the Travis CI matrix, it is a supported version.

## Quick Start

## When To Use ChefSpec?

As mentioned before, ChefSpec is built for speed. In order to run your tests as
quickly as possible (and to allow running tests on your workstation), ChefSpec
runs your recipe code with all the resource actions disabled. This means that
ChefSpec excels at testing complex logic in a cookbook, but can't actually tell
you if a cookbook is doing the right thing. Integration testing is provided by
the [Test Kitchen](https://kitchen.ci/) project, and for most simple cookbooks
without much logic in them we recommend you start off with integration tests and
only return to ChefSpec and unit tests as your code gets more complicated.

There are two common "units" of code in Chef cookbooks, custom resources and
recipes. If you find yourself with a lot of recipes that are so complex they
require unit tests, consider if they can be refactored as custom resources.

### Testing a Custom Resource

If you have have a cookbook with a custom resource `resources/greet.rb` like:

```ruby
resource_name :mycookbook_greet

property :greeting, String, default: 'Hello'

action :run do
  log "#{new_resource.greeting} world"
end
```

You can test that resource by creating a spec file `spec/greet_spec.rb`:

```ruby
# Load ChefSpec and put our test into ChefSpec mode.
require 'chefspec'

# Describing our custom resource.
describe 'mycookbook_greet' do
  # Normally ChefSpec skips running resources, but for this test we want to
  # actually run this one custom resource.
  step_into :mycookbook_greet
  # Nothing in this test is platform-specific, so use the latest Ubuntu for
  # simulated data.
  platform 'ubuntu'

  # Create an example group for testing the resource defaults.
  context 'with the default greeting' do
    # Set the subject of this example group to a snippet of recipe code calling
    # our custom resource.
    recipe do
      mycookbook_greet 'test'
    end

    # Confirm that the resources created by our custom resource's action are
    # correct. ChefSpec matchers all take the form `action_type(name)`.
    it { is_expected.to write_log('Hello world') }
  end

  # Create a second example group to test a different block of recipe code.
  context 'with a custom greeting' do
    # This time our test recipe code sets a property on the custom resource.
    recipe do
      mycookbook_greet 'test' do
        greeting 'Bonjour'
      end
    end

    # Use the same kind of matcher as before to confirm the action worked.
    it { is_expected.to write_log('Bonjour world') }
  end
end
```

And then run your test using `chef exec rspec`.

### Testing a Recipe

As a general rule of thumb, only very complex recipes benefit from ChefSpec unit
tests. If you find yourself writing a lot of recipe unit tests, consider converting
the recipes to custom resources instead. For the sake of example we'll use a
simple recipe, `recipes/farewell.rb`:

```ruby
log "#{node["mycookbook"]["farewell"]} world"
```

You can test that recipe by creating a spec file `spec/farewell_spec.rb`:

```ruby
# Load ChefSpec and put our test into ChefSpec mode.
require 'chefspec'

# Describing our recipe. The group name should be the recipe string as you would
# use it with include_recipe.
describe 'mycookbook::farewell' do
  # Nothing in this test is platform-specific, so use the latest Ubuntu for
  # simulated data.
  platform 'ubuntu'

  # Create an example group for testing the recipe defaults.
  context 'with default attributes' do
    # Since there was no `recipe do .. end` block here, the default subject is
    # recipe we named in the `describe`. ChefSpec matchers all take the form
    # `action_type(name)`.
    it { is_expected.to write_log('Goodbye world') }
  end

  # Create a second example group to test with attributes.
  context 'with a custom farewell' do
    # Set an override attribute for this group.
    override_attributes['mycookbook']['farewell'] = 'Adios'

    # Use the same kind of matcher as before to confirm the recipe worked.
    it { is_expected.to write_log('Adios world') }
  end
end
```

## Cookbook Dependencies

If your cookbook depends on other cookbooks, you must ensure ChefSpec knows how
to fetch those dependencies. If you use a monorepo-style layout with all your
cookbooks in a single `cookbooks/` folder, you don't need to do anything.

If you are using Berkshelf, `require 'chefspec/berkshelf'` in your spec file (or `spec_helper.rb`):

```ruby
require 'chefspec'
require 'chefspec/berkshelf'
```

If you are using a Policyfile, `require 'chefspec/policyfile'` in you spec file (or `spec_helper.rb`):

```ruby
require 'chefspec'
require 'chefspec/policyfile'
```

Your `Policyfile.rb` should look something like this:

```ruby
# The policy name is ignored but you need to specify one.
name 'my_cookbook'
# Pull dependent cookbooks from https://supermarket.chef.io/
default_source :supermarket
# The run list is also ignored by ChefSpec but you need to specify one.
run_list 'my_cookbook::default'
# The name here must match the name in metadata.rb.
cookbook 'my_cookbook', path: '.'
```

## Writing Tests

ChefSpec is an RSpec library, so if you're already familiar with RSpec you can
use all the normal spec-y goodness to which you are accustomed. The usual structure
of an RSpec test file is a file named like `spec/something_spec.rb` containing:

```ruby
require 'chefspec'

describe 'resource name or recipe' do
  # Some configuration for everything inside this `describe`.
  platform 'redhat', '7'
  default_attributes['value'] = 1

  context 'when some condition' do
    # Some configuration that only applies to this `context`.
    default_attributes['value'] = 2

    # `matcher` is some matcher function which we'll cover below.
    it { expect(value).to matcher }
    # There is a special value you can expect things on called `subject`, which
    # is the main thing being tested.
    it { expect(subject).to matcher }
    # And if prefer it for readability, `expect(subject)` can be written as `is_expected`.
    it { is_expected.to matcher }
  end

  context 'when some other condition' do
    # Repeat as needed.
  end
end
```

### ChefSpec Matchers

The primary matcher used with ChefSpec are resource matchers:

```ruby
it { expect(chef_run).to ACTION_RESOURCE('NAME') }
# Or equivalently.
it { is_expected.to ACTION_RESOURCE('NAME') }
```

This checks that a resource like `RESOURCE 'NAME'` would have run the specified
action if the cookbook was executing normally. You can also test for specific
property values:

```ruby
it { is_expected.to create_user('asmithee').with(uid: 512, gid: 45) }
# You can also use other RSpec matchers to create a "compound matcher". Check
# RSpec documentation for a full reference on the built-in matchers.
it { is_expected.to install_package('myapp').with(version: starts_with("3.")) }
```

#### `render_file`

For the common case of testing that a file is rendered to disk via either a
`template`, `file`, or `cookbook_file` resource, you can use a `render_file`
matcher:

```ruby
it { is_expected.to render_file('/etc/myapp.conf') }
# You can check for specific content in the file.
it { is_expected.to render_file('/etc/myapp.conf').with_content("debug = false\n") }
# Or with a regexp.
it { is_expected.to render_file('/etc/myapp.conf').with_content(/user = \d+/) }
# Or with a compound matcher.
it { is_expected.to render_file('/etc/myapp.conf').with_content(start_with('# This file managed by Chef')) }
# Or with a Ruby block of arbitrary assertions.
it do
  is_expected.to render_file('/etc/myapp.conf').with_content { |content|
    # Arbitrary RSpec code goes here.
  }
end
```

#### Notifications

As actions do not normally run in ChefSpec, testing for notifications is a special
case. Unlike the resource matchers which evaluate against the ChefSpec runner,
the notification matchers evaluate against a resource object:

```ruby
# To match `notifies :run, 'execute[unpack]', :immediately
it { expect(chef_run.remote_file('/download')).to notify('execute[unpack]') }
# To check for a specific notification action.
it { expect(chef_run.remote_file('/download')).to notify('execute[unpack]').to(:run) }
# And to check for a specific timing.
it { expect(chef_run.remote_file('/download')).to notify('execute[unpack]').to(:run).immediately }
```

And similarly for subscriptions:

```ruby
it { expect(chef_run.execute('unpack')).to subscribe_to('remote_file[/download]').on(:create) }
```

### Test Subject

RSpec expectations always need a value to run against, with the main value being
tested for a given example group (`describe` or `context` block) is called the
`subject`. In ChefSpec this is almost always `ChefSpec::Runner` that has converge
some recipe code.

There are two ways to set which recipe code should be run for the test. More commonly
for testing custom resources, you use the `recipe` helper method in the test to
provide an in-line block of recipe code:

```ruby
describe 'something' do
  recipe do
    my_custom_resource 'something' do
      debug true
    end
  end
end
```

By using an in-line block of recipe code, you can try many variations to test
different configurations of your custom resource.

If no `recipe` block is present, ChefSpec will use the name of the top-level
`describe` block as a recipe name to run. So for the case of testing a recipe
in your cookbook, use the `cookbookname::recipename` string as the label:

```ruby
describe 'mycookbook'
# Or.
describe 'mycookbook::myrecipe'
```

### Test Settings

Most ChefSpec configuration is set in your example groups (`describe` or `context`
blocks) using helper methods. These all follow the RSpec convention of inheriting
from a parent group to the groups inside it. So a setting in your top-level `describe`
will automatically be set in any `context` unless overridden:

```ruby
describe 'something' do
  platform 'ubuntu'

  # Platform is Ubuntu for any tests here.
  it { is_expected.to ... }

  context 'when something' do
    # Platform is still Ubuntu for any tests here.
  end

  context 'when something else' do
    platform 'fedora'
    # But platform here will be Fedora.
  end
end
```

#### Platform Data

To support simulating Chef runs on the same OS as you use your cookbooks on, ChefSpec
loads pre-fabricated Ohai data from [Fauxhai](https://github.com/chefspec/fauxhai/).
To configure which OS' data is set for your test, use the `platform` helper method:

```ruby
describe 'something' do
  platform 'ubuntu', '18.04'
  # ...
end
```

You can specify a partial version number to get the latest version of that OS
matching the provided prefix, or leave the version off entirely to get the latest
version overall:

```ruby
# Will use the latest RedHat 7.x.
platform 'redhat', '7'
# Will use the latest version of Windows.
platform 'windows'
```

**WARNING:** If you leave off the version or use a partial version prefix, the
behavior of your tests may change between versions of Chef Workstation as new data is
available in Fauxhai. Only use this feature if you're certain that your tests
do not (or should not) depend on the specifics of OS version.

#### Node Attributes

Node attributes are set using the `default_attributes`, `normal_attributes`,
`override_attributes`, and `automatic_attributes` helper methods. These inherit
from a parent group to its children using a deep merge, like in other places in
Chef:

```ruby
describe 'something' do
  default_attributes['myapp']['name'] = 'one'
  default_attributes['myapp']['email'] = 'myapp@example.com'

  context 'when something' do
    default_attributes['myapp']['name'] = 'two'
  end
end
```

Any values set using `automatic_attributes` take priority over Fauxhai data.

#### Step Into

Normally ChefSpec skips all resource (and provider) actions. When testing the
implementation of a custom resource, we need to tell ChefSpec to run actions
on our specific custom resource so it can be tested:

```ruby
describe 'something' do
  step_into :my_custom_resource
end
```


#### Other ChefSpec Configuration

You can specify any other ChefSpec configuration options using the `chefspec_options`
helper:

```ruby
describe 'something' do
  chefspec_options[:log_level] = :debug
end
```

### Stubbing

In order to keep unit tests fast and independent of the target system, we have to
make sure that any interaction with the system (either the target node or the Chef
Server, both parts of the system just in opposite directions) is replaced with a
fake, local version. For some thing, like ensuring that resource actions are
replaced with a no-op, the stubbing is automatic. For others, we need to tell ChefSpec
how to handle things.

#### Guards

The most common case of interacting with the system is a guard clause on a resource:

```ruby
not_if 'some command'
# Or.
only_if 'some command'
```

In order for ChefSpec to know how to evaluate the resource, we need to tell it
how the command would have returned for this test if it was running on the actual
machine:

```ruby
describe 'something' do
  recipe do
    execute '/opt/myapp/install.sh' do
      # Check if myapp is installed and runnable.
      not_if 'myapp --version'
    end
  end

  before do
    # Tell ChefSpec the command would have succeeded.
    stub_command('myapp --version').and_return(true)
    # Tell ChefSpec the command would have failed.
    stub_command('myapp --version').and_return(false)
    # You can also use a regexp to stub multiple commands at once.
    stub_command(/^myapp/).and_return(false)
  end
end
```

If using the Ruby code block form of a guard (e.g. `not_if { something }`), see
the [Ruby stubbing section](#ruby-code) below.

#### Search

When testing code that uses the `search()` API in Chef, we have to stub out the
results that would normally come from the Chef Server:

```ruby
describe 'something' do
  recipe do
    web_servers = search(:node, 'roles:web').map { |n| n['hostname'] }
  end

  before do
    stub_search(:node, 'roles:web').and_return([{hostname: 'one'}, {hostname: two}])
  end
end
```

#### Searches in libraries

When testing code in a library that uses `Chef::Search::Query.new.search()`, we have
to stub out the results that would normally come from the Chef Server:

```ruby
describe 'something' do
  recipe do
    results = Chef::Query::Search.new.search(:node, "tags:mytag AND chef_environment:my_env"))
  end

  before do
    query = double
    allow(query).to receive(:search) do |_, arg2|
    case arg2.downcase
    when /tags\:mytag AND chef_environment\:my_env/
        [
            [
                stub_node("server01", ohai: { hostname: "server01", ipaddress: '169.0.0.1' }, platform: 'windows', version: '2016'),
                stub_node("server02", ohai: { hostname: "server02", ipaddress: '169.0.0.2' }, platform: 'windows', version: '2016'),
            ],
            0,
            2,
        ]
    else
        [
            [],
            0,
            0
        ]
    end
    allow(Chef::Search::Query).to receive(:new).and_return(query)
  end
end
```

#### Data Bags

Similar to the Search API, the `data_bag()` and `data_bag_item()` APIs normally
fetch data from Chef Server so we need to stub their results:

```ruby
describe 'something' do
  recipe do
    # Side note: don't write recipe code like this. This should be `search(:users, '*:*')`.
    users = data_bag('users').map do |user|
      data_bag_item('users', user['id'])
    end
  end

  before do
    stub_data_bag('users').and_return(['asmithee'])
    stub_data_bag_item('users', 'asmithee').and_return({uid: 1234})
  end
end
```

#### Resource and Provider Methods

When testing custom resources, it is often useful to stub methods on the resource
or provider instance. These can be set up using the `stubs_for_resource` and
`stubs_for_provider` helpers:

```ruby
describe 'something' do
  recipe do
    my_custom_resource 'something'
  end

  # Set up stubs for just the one resource.
  stubs_for_resource('my_custom_resource[something]') do |res|
    # Can use any RSpec Mocks code here, see below.
    allow(res).to receive(:something)
  end
  # Stubs for any instance of my_custom_resource.
  stubs_for_resource('my_custom_resource') do |res|
    # ...
  end
  # Stubs for any resource.
  stubs_for_resource do |res|
    # ...
  end

  # Stubs for the provider for just the one resource.
  stubs_for_provider('my_custom_resource[something]') do |res|
    # Can use any RSpec Mocks code here, see below.
    allow(res).to receive(:something)
  end
  # And similar to the above for any provider of a type or any overall.
end
```

By default, stubs for the resource will also be set up on the `current_resource` and `after_resource` objects that are
created via `load_current_value`.  This can be disabled by using `stubs_for_resource('my_custom_resource[something]',
current_value: false)`.  You can also manually set stubs for only the `current_resource` and `after_resource` objects using
`stubs_for_current_value`.

#### Ruby Code

For more complex Ruby code, in recipes, libraries, or custom resources, you have
the full power of RSpec and RSpec Mocks available to you.

One issue that comes up often is stubbing filesystem checks such as `File.exist?`.  Since those are global class methods
by stubbing them they will be stubbed throughout the entire chef-client codebase that chefspec relies upon.  There are
many calls to `File.exist?` in any chefspec test that are not immediately visible to the user.  In order to
make the client behave correctly the pattern that should be followed is to allow all the chef-client calls to operate
normally using `and_call_original` and then to stub the exact path the test needs:

```ruby
before do
  allow(File).to receive(:exist?).and_call_original
  allow(File).to receive(:exist?).with('/test/path').and_return(true)
end
```

All the ruby methods off of the File, Dir and FileUtils classes along with any other global class methods that the
client might use, should follow a similar pattern for stubbing.

Check out the [RSpec Mocks documentation](https://relishapp.com/rspec/rspec-mocks/docs)
for more information about setting up Ruby method stubs.

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

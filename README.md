# ChefSpec
ChefSpec is a gem that makes it easy to write [RSpec](http://rspec.info/)  examples for
[Opscode Chef](http://www.opscode.com/chef/) cookbooks. Get fast feedback on cookbook changes before you spin up a node
to do integration testing against.

ChefSpec runs your cookbook but without converging the node that your examples are being executed on. This allows you
to write specs that make assertions about the created resources given the combination of your recipes and arbitrary node
attributes that you provide.

# Examples
[Examples and documentation](https://www.relishapp.com/acrmp/chefspec) on using ChefSpec are hosted on Relish.

# Compatibility
**This is alpha-quality at the moment**. The API is likely to change substantially. ChefSpec is currently tested with
Chef 0.9.18, 0.10.2 and 0.10.4 on MRI 1.8.7, 1.9.2 and 1.9.3.

# Building

    $ bundle install
    $ bundle exec rake

# Continuous Integration
[Chefspec on Travis CI](http://travis-ci.org/acrmp/chefspec)

![Built on Travis](https://secure.travis-ci.org/acrmp/chefspec.png?branch=master)

# License
MIT - see the accompanying [LICENSE](https://github.com/acrmp/chefspec/blob/master/LICENSE) file for details.

# Changelog
To see what has changed in recent versions see the [CHANGELOG](https://github.com/acrmp/chefspec/blob/master/CHANGELOG.md). ChefSpec follows the [Rubygems RationalVersioningPolicy](http://docs.rubygems.org/read/chapter/7).

# Contributing
Additional matchers and bugfixes are welcome! Please fork and submit a pull request on an individual branch per change.

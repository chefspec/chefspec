ChefSpec is a gem that makes it easy to write [RSpec](http://rspec.info/)  examples for
[Opscode Chef](http://www.opscode.com/chef/) cookbooks. Get fast feedback on cookbook changes before you spin up a node
to do integration testing against.

ChefSpec runs your cookbook but without converging the node that your examples are being executed on. This allows you
to write specs that make assertions about the created resources given the combination of your recipes and arbitrary node
attributes that you provide.


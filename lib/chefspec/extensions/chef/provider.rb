require 'chef/provider'
require 'chefspec/api'

Chef::Provider.prepend(Module.new do
  def self.name
    "ChefSpec extensions for Chef::Provider"
  end

  def self.inspect
    "#<Module: #{name}>"
  end

  def initialize(*args, &block)
    super(*args, &block)
    ChefSpec::API::StubsFor.setup_stubs_for(self, :provider) if $CHEFSPEC_MODE
  end
end)

require 'chef/provider'
require 'chefspec/api'

Chef::Provider.prepend(Module.new do
  def self.name
    "ChefSpec extensions for Chef::Provider"
  end

  def self.inspect
    "#<Module: #{name}>"
  end

  # Hook for the stubs_for system.
  def initialize(*args, &block)
    super(*args, &block)
    ChefSpec::API::StubsFor.setup_stubs_for(self, :provider) if $CHEFSPEC_MODE
  end

  # Defang shell_out and friends so it can never run.
  def shell_out(*args)
    return super unless $CHEFSPEC_MODE
    raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: 'provider', resource: new_resource)
  end
end)

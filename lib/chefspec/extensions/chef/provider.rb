require 'chef/provider'
require_relative '../../api'

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
  if ChefSpec::API::StubsFor::HAS_SHELLOUT_COMPACTED.satisfied_by?(Gem::Version.create(Chef::VERSION))
    def shell_out_compacted(*args)
      return super unless $CHEFSPEC_MODE
      raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: 'provider', resource: new_resource)
    end

    def shell_out_compacted!(*args)
      return super unless $CHEFSPEC_MODE
      shell_out_compacted(*args).tap {|c| c.error! }
    end
  else
    def shell_out(*args)
      return super unless $CHEFSPEC_MODE
      raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: 'provider', resource: new_resource)
    end
  end
end)

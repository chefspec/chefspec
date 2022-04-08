require "chef/mixin/shell_out"
require "chef/version"
require_relative "../../api/stubs_for"
require_relative "../../errors"

puts "being included!"

module ChefSpec::Extensions::Chef::ShellOut
  #
  # Defang shell_out and friends so it can never run.
  #
  if ChefSpec::API::StubsFor::HAS_SHELLOUT_COMPACTED.satisfied_by?(Gem::Version.create(Chef::VERSION))
    def shell_out_compacted(*args)
      puts "#shell_out_compacted"
      return super unless $CHEFSPEC_MODE
      puts "made it past return"

      raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: "resource", resource: self)
    end

    def shell_out_compacted!(*args)
      puts "#shell_out_compacted!"
      return super unless $CHEFSPEC_MODE
      puts "made it past return"

      shell_out_compacted(*args).tap(&:error!)
    end
  else
    def shell_out(*args)
      puts "#shell_out"
      return super unless $CHEFSPEC_MODE
      puts "made it past return"

      raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: "resource", resource: self)
    end
  end
end


module ChefSpec::Extensions::Chef::ShellOutOther
  def run_command(*args)
    raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: "resource", resource: self)
  end
end

::Mixlib::ShellOut.prepend(ChefSpec::Extensions::Chef::ShellOutOther)
::Chef::Mixin::ShellOut.prepend(ChefSpec::Extensions::Chef::ShellOut)
::Chef::Resource.prepend(ChefSpec::Extensions::Chef::ShellOut)
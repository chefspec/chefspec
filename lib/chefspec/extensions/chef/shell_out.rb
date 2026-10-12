require "chef/mixin/shell_out"
require "chef/resource"
require "chef/version"
require_relative "../../api/stubs_for"
require_relative "../../errors"

#
# Prepended onto +Chef::Resource+ so that a resource shelling out during a
# ChefSpec run raises instead of executing the command.
#
module ::ChefSpec::Extensions::Chef::ResourceShellOut
  #
  # Defang shell_out and friends so it can never run.
  #
  def shell_out_compacted(*args)
    return super unless $CHEFSPEC_MODE

    raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: "resource", resource: self)
  end

  #
  # Raise rather than executing the command, matching the bang variant's
  # contract of failing on a non-zero exit status.
  #
  # @param [Array] args
  #   the command and options the caller passed
  #
  # @raise [ChefSpec::Error::ShellOutNotStubbed, ChefSpec::Error::MixinShellOutNotStubbed]
  #   when running under ChefSpec without a matching stub
  #
  def shell_out_compacted!(*args)
    return super unless $CHEFSPEC_MODE

    shell_out_compacted(*args).tap(&:error!)
  end
end

#
# Prepended onto +Chef::Mixin::ShellOut+ so that library code shelling out
# during a ChefSpec run raises instead of executing the command.
#
module ::ChefSpec::Extensions::Chef::MixinShellOut
  #
  # Defang shell_out and friends so it can never run.
  #
  def shell_out_compacted(*args)
    return super unless $CHEFSPEC_MODE

    raise ChefSpec::Error::LibraryShellOutNotStubbed.new(args: args, object: self)
  end

  #
  # Raise rather than executing the command, matching the bang variant's
  # contract of failing on a non-zero exit status.
  #
  # @param [Array] args
  #   the command and options the caller passed
  #
  # @raise [ChefSpec::Error::ShellOutNotStubbed, ChefSpec::Error::MixinShellOutNotStubbed]
  #   when running under ChefSpec without a matching stub
  #
  def shell_out_compacted!(*args)
    return super unless $CHEFSPEC_MODE

    shell_out_compacted(*args).tap(&:error!)
  end
end

::Chef::Mixin::ShellOut.prepend(::ChefSpec::Extensions::Chef::MixinShellOut)
::Chef::Resource.prepend(::ChefSpec::Extensions::Chef::ResourceShellOut)

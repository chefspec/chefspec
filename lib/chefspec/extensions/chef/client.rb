# Force loading Chef Config to fix a bad dependency tree. See
# https://github.com/opscode/chef/issues/2703 for more information.
require 'chef/config'

# Providers has to be included before client... probably a weird
# include missing in Chef-land, but we can make sure we get it right anyway.
require 'chef/providers'
require 'chef/client'

# @private
Chef::Client.prepend(Module.new do
  #
  # Don't actually run ohai (we have fake data for that)
  #
  # @see Chef::Client#run_ohai
  #
  def run_ohai
    return super unless $CHEFSPEC_MODE
    # noop
  end
end)
